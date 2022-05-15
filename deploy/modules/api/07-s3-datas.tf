# copy lambda function code in the bucket
data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir  = "./lambdas/build"
  output_path = "./lambdas/build/hello-world.zip"
}

resource "aws_s3_object" "lambda_hello_world" {
  bucket = aws_s3_bucket.b.id

  key    = "hello-world.zip"
  source = data.archive_file.lambda_hello_world.output_path

  etag = filemd5(data.archive_file.lambda_hello_world.output_path)
}