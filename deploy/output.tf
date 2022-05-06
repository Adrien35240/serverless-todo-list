# bucket output
output "lambda_buckettodolist" {
  description = "Lambda store bucket name :"
  value = aws_s3_bucket.lambda_buckettodolist.id
}