output "http-front-url" {
  value = "http://${aws_lb.todo.dns_name}"
}

output "http-domain-url" {
  value = "http://${aws_route53_record.todo-www.fqdn}"
}

output "ecr_repository-uri" {
  value = "${aws_ecr_repository.todo.repository_url}"
}
# Output value definitions
# bucket output
output "todo-lambda" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.todo-lambda.id
}
# lamba function output
output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.todo-lambda-hello.function_name
}
# api gateway output => return the url
output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.todo-lambda.invoke_url
}
