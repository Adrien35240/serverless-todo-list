# create ecr ressource
resource "aws_ecr_repository" "ecr_repo" {
  name = var.app_name
}
