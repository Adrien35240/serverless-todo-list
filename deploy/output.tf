# bucket output
output "lambda_buckettodolist" {
  description = "Lambda store bucket name :"
  value = aws_s3_bucket.lambda_buckettodolist.id
}
# lamba function output
output "hello_world" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.hello_world.function_name
}