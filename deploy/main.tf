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

