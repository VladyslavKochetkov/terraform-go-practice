variable "aws_region" {
  default     = "us-east-2"
  description = "AWS deployment region"
  type        = string
}

variable "lambda_name" {
  description = "AWS Lambda name"
  type        = string
}

variable "lambda_runtime" {
  description = "AWS Lambda runtime"
  type        = string
}

variable "lambda_handler" {
  description = "AWS Lambda handler"
  type        = string
}

variable "lambda_policy_statements" {
  type = list(object({
    Action   = list(string)
    Effect   = string
    Resource = string
  }))
  default     = []
  description = "The IAM Policy that will be attached to the lambda - logging is already included"
}

variable "data_source_path" {
  type = string
}
