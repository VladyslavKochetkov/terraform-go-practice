terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15"
    }
  }
}

resource "aws_apigatewayv2_api" "api_gw" {
  name                       = var.api_gw_name
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}
