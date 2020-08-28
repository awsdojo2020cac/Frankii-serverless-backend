resource "aws_lambda_function" "get_question_categories" {
  function_name = var.frankii_get_question_categories_function_name
  filename      = "../app/${var.frankii_get_question_categories_function_name}.zip"

  # "var.frankii_get_question_categories_function_name" is the filename within the zip file
  #(${var.frankii_get_question_categories_function_name}.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "${var.frankii_get_question_categories_function_name}.handler"
  runtime = "nodejs12.x"

  role = aws_iam_role.frankii_lambda_iam_role.arn
}

resource "aws_lambda_function" "get_input_template" {
  function_name = var.frankii_get_input_template_function_name
  filename      = "../app/${var.frankii_get_input_template_function_name}.zip"
  handler       = "${var.frankii_get_input_template_function_name}.handler"
  runtime       = "nodejs12.x"

  role = aws_iam_role.frankii_lambda_iam_role.arn
}

resource "aws_lambda_function" "register_input_template" {
  function_name = var.frankii_register_input_template_function_name
  filename      = "../app/${var.frankii_register_input_template_function_name}.zip"
  handler       = "${var.frankii_register_input_template_function_name}.handler"
  runtime       = "nodejs12.x"

  role = aws_iam_role.frankii_lambda_iam_role.arn
}

resource "aws_lambda_function" "format_service" {
  function_name = var.frankii_format_service_function_name
  filename      = "../app/${var.frankii_get_question_categories_function_name}.zip"
  handler       = "${var.frankii_get_question_categories_function_name}.handler"
  runtime       = "nodejs12.x"

  role = aws_iam_role.frankii_lambda_iam_role.arn
}

resource "aws_lambda_function" "delete_input_template" {
  function_name = var.frankii_delete_input_template_function_name
  filename      = "../app/${var.frankii_delete_input_template_function_name}.zip"
  handler       = "${var.frankii_delete_input_template_function_name}.handler"
  runtime       = "nodejs12.x"

  role = aws_iam_role.frankii_lambda_iam_role.arn
}

resource "aws_lambda_function" "get_auth" {
  function_name = var.frankii_get_auth
  filename      = "../app/${var.frankii_get_auth}.zip"
  handler       = "${var.frankii_get_auth}.handler"
  runtime       = "nodejs12.x"

  role = aws_iam_role.frankii_lambda_iam_role.arn

  environment {
    variables = {
      SLACK_CLIENT_ID     = var.SLACK_CLIENT_ID
      SLACK_CLIENT_SECRET = var.SLACK_CLIENT_SECRET
      TOKEN_TABLE         = "frankii-tokens"
    }
  }
}


# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "frankii_lambda_iam_role" {
  name               = "frankii_lambda_iam_role"
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

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  //  leaving for_each here in case multiple role policies need to be attached in future
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  ])

  role       = aws_iam_role.frankii_lambda_iam_role.name
  policy_arn = each.value
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  for_each = toset([
    aws_lambda_function.get_question_categories.function_name,
    aws_lambda_function.get_input_template.function_name,
    aws_lambda_function.register_input_template.function_name,
    aws_lambda_function.format_service.function_name,
    aws_lambda_function.delete_input_template.function_name,
    aws_lambda_function.get_auth.function_name
  ])

  statement_id = "AllowAPIGatewayInvoke"
  action       = "lambda:InvokeFunction"

  function_name = each.value
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.frankii_api.execution_arn}/*/*"
}
