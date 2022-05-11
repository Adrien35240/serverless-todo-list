# create ecr ressource
resource "aws_ecr_repository" "private-ecr" {
  name                 = "private-ecr"
  image_scanning_configuration {
    scan_on_push = true
  }
}

