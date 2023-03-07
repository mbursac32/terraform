include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-aws-modules/security-group/aws?version=4.17.1"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name                = "ecs-asg"
  description         = "Autoscaling group security group"
  vpc_id              = dependency.vpc.outputs.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]

  egress_rules = ["all-all"]

  tags = {
    Terraform = "true"
    Environment = "staging"
  }


}

dependencies {
  paths = ["../vpc"]
}