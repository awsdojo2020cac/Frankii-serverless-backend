output "base_url" {
  value = aws_api_gateway_deployment.frankii_api_gateway_deployment.invoke_url
}