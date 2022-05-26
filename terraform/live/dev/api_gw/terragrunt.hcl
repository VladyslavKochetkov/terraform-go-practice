terraform {
  source = "./../../..//modules/api_gw"
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
  api_gw_name = "test_go"
}
