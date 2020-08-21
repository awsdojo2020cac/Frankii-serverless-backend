resource "aws_api_gateway_rest_api" "frankii_api" {
  name        = "Frankii API"
  description = "Frankii's API"
}

resource "aws_api_gateway_resource" "user_resource" {
  rest_api_id = aws_api_gateway_rest_api.frankii_api.id
  parent_id   = aws_api_gateway_rest_api.frankii_api.root_resource_id
  path_part   = "user"
}

resource "aws_api_gateway_resource" "question_category" {
  rest_api_id = aws_api_gateway_rest_api.frankii_api.id
  parent_id   = aws_api_gateway_resource.user_resource.id
  path_part   = "question-categories"
}

resource "aws_api_gateway_method" "get_question_categories" {
  rest_api_id   = aws_api_gateway_rest_api.frankii_api.id
  resource_id   = aws_api_gateway_resource.question_category.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_question_categories_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.frankii_api.id
  resource_id = aws_api_gateway_method.get_question_categories.resource_id
  http_method = aws_api_gateway_method.get_question_categories.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_question_categories.invoke_arn
}

resource "aws_api_gateway_resource" "input_template" {
  rest_api_id = aws_api_gateway_rest_api.frankii_api.id
  parent_id   = aws_api_gateway_resource.user_resource.id
  path_part   = "input-template"
}

resource "aws_api_gateway_resource" "category" {
  rest_api_id = aws_api_gateway_rest_api.frankii_api.id
  parent_id   = aws_api_gateway_resource.input_template.id
  path_part   = "{category}"
}

resource "aws_api_gateway_method" "get_input_template" {
  rest_api_id   = aws_api_gateway_rest_api.frankii_api.id
  resource_id   = aws_api_gateway_resource.category.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.category" = true
  }
}

resource "aws_api_gateway_integration" "get_input_template_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.frankii_api.id
  resource_id = aws_api_gateway_method.get_input_template.resource_id
  http_method = aws_api_gateway_method.get_input_template.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_input_template.invoke_arn

  request_parameters = {
    "integration.request.path.category" = "method.request.path.category"
  }
}

resource "aws_api_gateway_deployment" "frankii_api_gateway_deployment" {
  depends_on = [
    aws_api_gateway_integration.get_question_categories_lambda_integration,
    aws_api_gateway_integration.get_input_template_lambda_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.frankii_api.id
  stage_name  = var.deploy_stage
}
