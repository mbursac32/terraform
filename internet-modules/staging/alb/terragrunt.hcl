include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-aws-modules/alb/aws?version=8.4.0"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "asg-sg" {
  config_path = "../asg-sg"
  mock_outputs = {
    security_group_id = "sg-fb07dasd2"
  }
}

inputs = {

  name               = "marko-test-ecs"
  load_balancer_type = "application"
  vpc_id             = dependency.vpc.outputs.vpc_id
  subnets            = [dependency.vpc.outputs.public_subnets[0], dependency.vpc.outputs.public_subnets[1], dependency.vpc.outputs.public_subnets[2]]
  security_groups    = [dependency.asg-sg.outputs.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name_prefix      = "ecs-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "ip"
    }
  ]

}

dependencies {
  paths = ["../vpc", "../asg-sg"]
}