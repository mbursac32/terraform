include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "./hello-world-service"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "ecs" {
  config_path = "../ecs"
}

dependency "alb" {
  config_path = "../alb"
}

dependency "asg-sg" {
  config_path = "../asg-sg"
}

inputs = {
  cluster_id       = dependency.ecs.outputs.cluster_id
  desired_count    = 5
  image            = "nginx"
  subnets          = [dependency.vpc.outputs.public_subnets[0], dependency.vpc.outputs.public_subnets[1], dependency.vpc.outputs.public_subnets[2]]
  security_groups  = [dependency.asg-sg.outputs.security_group_id]
  target_group_arn = dependency.alb.outputs.target_group_arns[0]
  container_name   = "marko-test-task-definition"
}

dependencies {
  paths = ["../vpc", "../ecs", "../alb", "../asg-sg"]
}