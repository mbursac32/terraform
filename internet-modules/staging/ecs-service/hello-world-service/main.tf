resource "aws_cloudwatch_log_group" "this" {
  name_prefix       = var.name_prefix
  retention_in_days = var.retention_in_days
}

resource "aws_ecs_task_definition" "this" {
  family       = var.family
  network_mode = "awsvpc"

  container_definitions = <<EOF
[
  {
    "name": "${var.family}",
    "image": "${var.image}",
    "cpu": ${var.cpu},
    "memory": ${var.memory},
    "portMappings": [
      {
        "containerPort": ${var.containerPort}
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${var.region}",
        "awslogs-group": "${aws_cloudwatch_log_group.this.name}",
        "awslogs-stream-prefix": "ec2"
      }
    }
  }
]
EOF
}

resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this.arn

  desired_count = var.desired_count

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = false
    security_groups  = var.security_groups
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

}