locals {
  application_name = "tf-fargate"
  launch_type = "FARGATE"
}

resource "aws_ecs_cluster" "ecs_cluster" {
    name = local.application_name
}



resource "aws_ecs_service" "ecs_cluster" {
  name = "terraform_service"
  cluster = aws_ecs_cluster.ecs_cluster.id

  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 0
  desired_count = 1
  launch_type = local.launch_type
  task_definition = aws_ecs_task_definition.terraform-task.id

  network_configuration {
    assign_public_ip = true
    subnets          = aws_subnet.private.*.id
  }

 
}