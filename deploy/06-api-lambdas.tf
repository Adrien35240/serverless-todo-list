resource "aws_lambda_function" "todo-lambda-hello" {
  function_name = "HelloWorld"

  s3_bucket = aws_s3_bucket.todo-lambda.id
  s3_key    = aws_s3_object.todo-lambda.key

  runtime = "nodejs14.x"
  handler = "hello.handler"

  source_code_hash = data.archive_file.todo-lambda.output_base64sha256

  role = aws_iam_role.todo-lambda.arn
}


resource "aws_iam_role" "todo-lambda" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "todo-lambda" {
  role       = aws_iam_role.todo.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

