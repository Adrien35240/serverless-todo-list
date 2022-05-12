# create ecr ressource
resource "aws_ecr_repository" "private-ecr" {
  name                 = "private-ecr"
  image_tag_mutability = "MUTABLE"
}

