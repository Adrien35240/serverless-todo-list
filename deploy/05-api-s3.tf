# create random name for the bucket b
resource "random_pet" "todo-lambda" {
  prefix = "todo-lambda-"
  length = 4
}
# create s3 bucket
resource "aws_s3_bucket" "todo-lambda" {
  bucket = random_pet.todo-lambda.id

  tags = {
    Name        = "todo-lambda-bucket"
  }
}

resource "aws_s3_bucket_acl" "todo-lambda" {
  bucket = aws_s3_bucket.todo-lambda.id
  acl    = "private"
}
# copy lambda function code in the bucket
data "archive_file" "todo-lambda" {
  type = "zip"

  source_dir  = "./lambdas/build"
  output_path = "./lambdas/build/hello-world.zip"
}

resource "aws_s3_object" "todo-lambda" {
  bucket = aws_s3_bucket.todo-lambda.id

  key    = "hello-world.zip"
  source = data.archive_file.todo-lambda.output_path

  etag = filemd5(data.archive_file.todo-lambda.output_path)
}