terraform {
  source = "./../../..//modules/lambda"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "us-east-2"
  profile = "personal"
}
EOF
}

inputs = {
  data_source_path = "${get_repo_root()}/lambda_code/testing_go/main"
  lambda_name      = "testing_go"
  lambda_runtime   = "go1.x"
  lambda_handler   = "main"
}
