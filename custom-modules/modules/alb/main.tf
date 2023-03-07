resource "aws_lb" "lb" {
  name                       = var.name
  internal                   = var.internal
  load_balancer_type         = var.load_balancer_type
  security_groups            = [aws_security_group.allow_http_lb.id]
  subnets                    = var.subnets
  enable_deletion_protection = false

  tags = var.tags

}

resource "aws_security_group" "allow_http_lb" {
  name        = "allow_http_lb"
  description = "Allow http inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTP from internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }

  tags = var.tags
}

resource "aws_lb_target_group" "lb_tg" {
  name        = "lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    interval = 5
    timeout  = 2
  }

 tags = var.tags
}

