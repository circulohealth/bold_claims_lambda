terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}

provider "aws" {
    region = "us-east-2"
}

resource "aws_lambda_function" "returns_a_string" {
    function_name = "returns_a_string"

    s3_bucket = var.s3_bucket
    s3_key = "v1.1.1/returns_a_string.zip"

    handler = "returns_a_string.handler"
    runtime = "python3.8"

    # Marking this role for later configuration
    # Will need to modify this for neptune use later
    role = aws_iam_role.default_lambda_exec.arn
}

resource "aws_lambda_function" "get_member_by_id" {
    function_name = "get_member_by_id"

    s3_bucket = var.s3_bucket
    s3_key = "v${var.app_version}/get_member_by_id.zip"

    handler = "get_member_by_id.handler"
    runtime = "python3.8"

    timeout = 12
    memory_size = 512

    vpc_config {
        security_group_ids = [
            "sg-e4f5d8ad",
        ]
        subnet_ids = [
            "subnet-3531cb48",
            "subnet-7a92b036",
            "subnet-91ae22fa",
        ]
    }

    # Marking this role for later configuration
    # Will need to modify this for neptune use later
    role = aws_iam_role.default_lambda_exec.arn
}

# IAM Role to give Lambda access to other services
resource "aws_iam_role" "default_lambda_exec" {
    name = "default_lambda_exec"
    
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

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
    role       = aws_iam_role.default_lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_permission" "apigw_returns_a_string" {
    statement_id = "AllowAPIGatewayInvoke"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.returns_a_string.function_name
    principal = "apigateway.amazonaws.com"

    # The "/*/*" portion grants access from any method on any resource
    # within the API Gateway REST API.
    source_arn = "${aws_api_gateway_rest_api.membership_eligibility.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_get_member_by_id" {
    statement_id = "AllowAPIGatewayInvoke"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.get_member_by_id.function_name
    principal = "apigateway.amazonaws.com"

    # The "/*/*" portion grants access from any method on any resource
    # within the API Gateway REST API.
    source_arn = "${aws_api_gateway_rest_api.membership_eligibility.execution_arn}/*/*"
}