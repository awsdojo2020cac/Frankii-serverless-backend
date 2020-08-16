resource "aws_lambda_function" "get_question_categories" {
  function_name = var.frankii_get_question_categories_function_name

  # The bucket name as created earlier with in ../s3
  s3_bucket = "frankii-lambda-functions"
  s3_key    = "v${var.app_version}/${var.frankii_get_question_categories_function_name}.zip"

  # "var.frankii_get_question_categories_function_name" is the filename within the zip file
  #(${var.frankii_get_question_categories_function_name}.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "${var.frankii_get_question_categories_function_name}.handler"
  runtime = "nodejs12.x"

  role = aws_iam_role.frankii_lambda_iam_role.arn
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

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  //  leaving for_each here in case multiple role policies need to be attached in future
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  ])

  role       = aws_iam_role.frankii_lambda_iam_role.name
  policy_arn = each.value
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_question_categories.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.frankii_api.execution_arn}/*/*"
}
