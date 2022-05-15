resource "aws_vpc" "vpc-terraform" {
  cidr_block       = "10.0.0.0/16"
}

# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
  count             = 1
  cidr_block        = cidrsubnet(aws_vpc.vpc-terraform.cidr_block, 8, count.index)
  vpc_id            = aws_vpc.vpc-terraform.id
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  count                   = 1
  cidr_block              = cidrsubnet(aws_vpc.vpc-terraform.cidr_block, 8, 1 + count.index)
  vpc_id                  = aws_vpc.vpc-terraform.id
  map_public_ip_on_launch = true
}
