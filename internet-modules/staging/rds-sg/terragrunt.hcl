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
  name                = "rds-sg"
  description         = "Autoscaling group security group"
  vpc_id              = dependency.vpc.outputs.vpc_id
  ingress_cidr_blocks = [dependency.vpc.outputs.vpc_cidr_block]
  ingress_rules       = ["mysql-tcp"]

  egress_rules = ["all-all"]

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }


}

dependencies {
  paths = ["../vpc"]
}