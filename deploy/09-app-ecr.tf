resource "aws_ecr_repository" "todo" {
    name = "${var.app_name}"
}
