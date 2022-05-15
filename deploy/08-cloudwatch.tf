resource "aws_cloudwatch_log_group" "todo-lambda-hello" {
  name              = "/aws/lambda/${aws_lambda_function.todo-lambda-hello.function_name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "todo-lambda-api_gw" {
  name              = "/aws/api_gw/${aws_apigatewayv2_api.todo-lambda.name}"
  retention_in_days = 30
}
