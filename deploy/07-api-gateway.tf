# API Gateway
resource "aws_apigatewayv2_api" "todo-lambda" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "todo-lambda" {
  api_id = aws_apigatewayv2_api.todo-lambda.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.todo-lambda-api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "todo-lambda" {
  api_id = aws_apigatewayv2_api.todo-lambda.id

  integration_uri    = aws_lambda_function.todo-lambda-hello.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "todo-lambda" {
  api_id = aws_apigatewayv2_api.todo-lambda.id

  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.todo-lambda.id}"
}


resource "aws_lambda_permission" "todo-lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.todo-lambda-hello.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.todo-lambda.execution_arn}/*/*"
}
