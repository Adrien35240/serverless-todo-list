# Output value definitions
# bucket output
output "b" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.b.id
}
# lamba function output
output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.hello_world.function_name
}
# api gateway output => return the url
output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.lambda.invoke_url
}
# ecr output
output "private-ecr" {
  description = "url of the todo app"
  value = aws_ecr_repository.private-ecr.repository_url
}
