resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policy" {
  repository = aws_ecr_repository.private-ecr.name
  policy     = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Expire untagged images older than 14 days",
        "selection" : {
          "tagStatus" : "untagged",
          "countType" : "sinceImagePushed",
          "countUnit" : "days",
          "countNumber" : 14
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })
}
resource "aws_iam_role" "myroles" {
  name = "myroles"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "build.apprunner.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "myrolespolicy" {
  role = aws_iam_role.myroles.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "time_sleep" "waitrolecreate" {
  depends_on = [aws_iam_role.myroles]
  create_duration = "60s"
}

resource "aws_apprunner_service" "my-app-runner" {
  depends_on = [time_sleep.waitrolecreate]
  service_name = "my-app-runner"
  source_configuration {
    authentication_configuration {
      access_role_arn = "${aws_iam_role.myroles.arn}"
    }
    image_repository {
      image_identifier      = "${aws_ecr_repository.private-ecr.repository_url}:latest"
      image_repository_type = "ECR"
      image_configuration {
        port = 80
      }
    }
  }
}