# This is a parent level container that holds all APIs related to
# membership eligibility
resource "aws_api_gateway_rest_api" "membership_eligibility" {
    name = "MembershipEligibility"
    description = "API container for MembershipEligibility related CRUD operations"
}

###
# returns_a_string test method lambda invocation
###
resource "aws_api_gateway_resource" "returns_a_string" {
    rest_api_id = aws_api_gateway_rest_api.membership_eligibility.id
    parent_id = aws_api_gateway_rest_api.membership_eligibility.root_resource_id
    path_part = "returns_a_string"
}

resource "aws_api_gateway_method" "returns_a_string" {
    rest_api_id = aws_api_gateway_rest_api.membership_eligibility.id
    resource_id = aws_api_gateway_resource.returns_a_string.id
    http_method = "GET"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "returns_a_string_lambda" {
    rest_api_id = aws_api_gateway_rest_api.membership_eligibility.id
    resource_id = aws_api_gateway_method.returns_a_string.resource_id
    http_method = aws_api_gateway_method.returns_a_string.http_method

    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = aws_lambda_function.returns_a_string.invoke_arn
}

###
# get_member_by_id method lambda integration
###
resource "aws_api_gateway_resource" "get_member_by_id" {
    rest_api_id = aws_api_gateway_rest_api.membership_eligibility.id
    parent_id = aws_api_gateway_rest_api.membership_eligibility.root_resource_id
    path_part = "get_member_by_id"
}

resource "aws_api_gateway_method" "get_member_by_id" {
    rest_api_id = aws_api_gateway_rest_api.membership_eligibility.id
    resource_id = aws_api_gateway_resource.get_member_by_id.id
    http_method = "POST"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_member_by_id_lambda" {
    rest_api_id = aws_api_gateway_rest_api.membership_eligibility.id
    resource_id = aws_api_gateway_method.get_member_by_id.resource_id
    http_method = aws_api_gateway_method.get_member_by_id.http_method

    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = aws_lambda_function.get_member_by_id.invoke_arn
}


####
# Create gateway deployment
resource "aws_api_gateway_deployment" "membership_eligibility" {
    depends_on = [
        aws_api_gateway_integration.get_member_by_id_lambda,
        aws_api_gateway_integration.returns_a_string_lambda,
    ]

    rest_api_id = aws_api_gateway_rest_api.membership_eligibility.id
    stage_name = "sapphire"
}

output "base_url" {
    value = aws_api_gateway_deployment.membership_eligibility.invoke_url
}