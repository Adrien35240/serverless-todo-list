resource "aws_ecs_task_definition" "terraform-task" {
  family                   = local.application_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "terraform-appContainer",
    "image": "141115429158.dkr.ecr.eu-west-3.amazonaws.com/private-ecr:latest",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "portMappings": [
            {
                "containerPort": 3000,
                "hostPort": 3000,
                "protocol": "tcp"
            }
        ]
  }
]
TASK_DEFINITION
  execution_role_arn = "arn:aws:iam::141115429158:role/ecsTaskExecutionRole"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
