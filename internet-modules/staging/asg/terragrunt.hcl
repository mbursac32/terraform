include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-aws-modules/autoscaling/aws?version=6.7.1"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "asg-sg" {
  config_path = "../asg-sg"
  mock_outputs = {
    security_group_id  = "sg-fb07dasd2"
  }
}


locals {
  user_data = <<-EOT
    #!/bin/bash
    cat <<'EOF' >> /etc/ecs/ecs.config
    ECS_CLUSTER=marko-ecs-test
    ECS_LOGLEVEL=debug
    EOF
  EOT
}

inputs = {
  
  name = "ecs-asg"
  image_id                        = "ami-06c1d5fe67809f5dd"
  instance_type                   = "t3a.medium"
  security_groups                 = [dependency.asg-sg.outputs.security_group_id]
  ignore_desired_capacity_changes = true
  user_data                       = base64encode(local.user_data)
  create_iam_instance_profile = true
  iam_role_name               = "ecs-asg"
  iam_role_description        = "ECS role for ecs-asg"
  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  launch_template_name        = "ecs-asg"
  launch_template_description = "Launch template ECS"
  update_default_version      = true
  vpc_zone_identifier = dependency.vpc.outputs.public_subnets
  health_check_type   = "EC2"
  min_size            = 0
  max_size            = 2
  desired_capacity    = 1

  autoscaling_group_tags = {
    AmazonECSManaged = true
  }

protect_from_scale_in = true

  tags = {
    Terraform = "true"
    Environment = "staging"
  }


}

dependencies {
  paths = ["../vpc", "../asg-sg"]
}