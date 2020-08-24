resource "aws_api_gateway_rest_api" "frankii_api" {
  name        = var.api_name
  description = "Frankii's API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  body = templatefile("../frankii-api.yaml", {
    title                                       = var.api_name
    get_question_categories_function_invoke_arn = aws_lambda_function.get_question_categories.invoke_arn
    get_input_template_function_invoke_arn      = aws_lambda_function.get_input_template.invoke_arn
    register_input_template_function_invoke_arn = aws_lambda_function.register_input_template.invoke_arn
  })
}

resource "aws_api_gateway_deployment" "frankii_api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.frankii_api.id
  stage_name  = var.deploy_stage

  depends_on = [aws_api_gateway_rest_api.frankii_api]
}
