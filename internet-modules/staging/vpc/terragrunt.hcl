terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=3.19.0"
}

inputs = {
  name = "marko-test-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  elasticache_subnets = ["10.0.31.0/24", "10.0.32.0/24", "10.0.33.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false
  
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform = "true"
    Environment = "staging"
  }
}

include "root" {
  path = find_in_parent_folders()
}