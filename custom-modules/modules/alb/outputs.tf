output "sg_id" {
  value = aws_security_group.allow_http_lb.id
}

output "target_arn" {
  value = aws_lb_target_group.lb_tg.arn
}