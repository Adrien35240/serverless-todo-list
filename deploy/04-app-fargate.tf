
resource "aws_ecs_task_definition" "todo" {
    family = "${var.app_name}-task-definition"

    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    memory = "512"
    cpu = "256"
    execution_role_arn = "${aws_iam_role.todo.arn}"
   
    container_definitions = <<EOT
[
    {
        "name": "${var.app_name}_container",
        "image": "${aws_ecr_repository.todo.repository_url}:latest",
        "memory": 512,
        "essential": true,
        "portMappings": [
            {
                "containerPort": 80,
                "hostPort": 80
            }
        ]
    }
]
EOT

}

resource "aws_ecs_cluster" "todo" {
    name = "${var.app_name}"
}

resource "aws_ecs_service" "todo" {
    name = "${var.app_name}"
    force_new_deployment = true
    cluster = "${aws_ecs_cluster.todo.id}"
    task_definition = "${aws_ecs_task_definition.todo.arn}"
    launch_type = "FARGATE"
    desired_count = 1
    load_balancer {
      target_group_arn = aws_lb_target_group.todo.arn
      container_name = "${var.app_name}_container"
      container_port = 80
    }
    network_configuration {
        subnets = ["${aws_subnet.public_a.id}"]
        security_groups = ["${aws_security_group.todo.id}"]
        assign_public_ip = true
    }
}
