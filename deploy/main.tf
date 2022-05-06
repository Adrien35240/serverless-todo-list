terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>4.0.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~>3.1.0"
    }
     archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
  required_version = "~> 1.0"
}
provider "aws" {
  region = var.aws_region
}

# Generate random id 
resource "random_id" "random_idtodolist" {
  prefix = "sta-"
  byte_length = 2
}
# create s3 bucket
resource "aws_s3_bucket" "lambda_buckettodolist" {
  bucket = random_id.random_idtodolist.hex

  tags = {
    Name = "TodoList bucket ${random_id.random_idtodolist.hex}"
    Environment = "Dev"
  }
}
# set acl for bucket to private
resource "aws_s3_bucket_acl" "acl_buckettodolist" {
  bucket = aws_s3_bucket.lambda_buckettodolist.id
  acl = "private"
}

# copy lambda function code in the bucket
data "archive_file" "lambda_helloworld_tl" {
  type = "zip"

  source_dir  = "../lambdas"
  output_path = "${path.module}/helloworld.zip"
}

resource "aws_s3_object" "lambda_helloworld_tl" {
  bucket = aws_s3_bucket.lambda_buckettodolist.id

  key    = "helloworld.zip"
  source = data.archive_file.lambda_helloworld_tl.output_path

  etag = filemd5(data.archive_file.lambda_helloworld_tl.output_path)
}

# define the lambda function
resource "aws_lambda_function" "hello_world" {
  function_name = "HelloWorld"

  s3_bucket = aws_s3_bucket.lambda_buckettodolist.id
  s3_key    = aws_s3_object.lambda_helloworld_tl.key

  runtime = "nodejs14.x"
  handler = "hello.handler"

  source_code_hash = data.archive_file.lambda_helloworld_tl.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "hello_world" {
  name = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
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

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}