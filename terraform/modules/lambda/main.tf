terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15"
    }
  }
}

resource "random_pet" "name" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  lambda_name = replace("${var.lambda_name}-${random_pet.name.id}", "_", "-")
  policy = [
    {
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:log-group:/aws/lambda/${local.lambda_name}:*"
    }
  ]
}

resource "aws_iam_role" "role" {
  name               = "${local.lambda_name}-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name = "${local.lambda_name}-policy"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = flatten([local.policy, var.lambda_policy_statements])
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_s3_bucket" "code_storage" {
  bucket = "${local.lambda_name}-code-storage"
}

resource "aws_s3_bucket_versioning" "code_source_versioning" {
  bucket = aws_s3_bucket.code_storage.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "archive_file" "code_storage_item_source" {
  type        = "zip"
  output_path = "./lambda_source.zip"
  source_dir  = var.data_source_path
}

resource "aws_s3_object" "code_storge_item" {
  bucket = aws_s3_bucket.code_storage.bucket
  key    = "${local.lambda_name}-source.zip"
  source = archive_file.code_storage_item_source.output_path
  etag   = filemd5(archive_file.code_storage_item_source.output_path)
}

resource "aws_lambda_function" "lambda_function" {
  function_name = local.lambda_name
  runtime       = var.lambda_runtime
  role          = aws_iam_role.role.arn
  handler       = var.lambda_handler

  s3_bucket = aws_s3_bucket.code_storage.bucket
  s3_key    = aws_s3_object.code_storge_item.key

  depends_on = [
    aws_s3_object.code_storge_item
  ]
}

