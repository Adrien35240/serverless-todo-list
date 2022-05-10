# create random name for the bucket b
resource "random_pet" "b" {
  prefix = "learn-terraform-functions"
  length = 4
}
# create s3 bucket
resource "aws_s3_bucket" "b" {
  bucket = random_pet.b.id

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}