resource "aws_security_group" "ecs_container" {
  name        = var.sg_name
  description = "Allow http inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = var.security_groups
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags

}

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "ecs" {
  count              = var.release_version != "" ? 1 : 0
  family             = var.family
  execution_role_arn = var.execution_role_arn
  container_definitions = jsonencode([
    {
      name      = var.task_definition_name
      image     = "${var.image_name}:${var.release_version}"
      essential = var.essential

      portMappings = [
        {
          containerPort = var.containerPort
        }
      ]
    }
  ])

  requires_compatibilities = var.requires_compatibilities

  network_mode = "awsvpc"
  cpu          = "256"
  memory       = "512"
}

resource "aws_ecs_service" "ecs" {
  count           = var.release_version != "" ? 1 : 0
  name            = var.service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.ecs[0].arn
  desired_count   = var.desired_count
  launch_type     = var.launch_type

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = jsondecode(aws_ecs_task_definition.ecs[0].container_definitions)[0].name
    container_port   = var.containerPort
  }

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_container.id]
  }
}

