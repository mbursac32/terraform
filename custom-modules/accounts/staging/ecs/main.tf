module "vpc" {
  source = "../../../modules/vpc"

  env                       = "staging"
  public_subnet_cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  vpc_cidr_block            = "10.10.0.0/16"

  tags = {
    Name = "marko-test"
    Env  = "staging"
  }
}

module "ecr" {
  source = "../../../modules/ecr"

  name                 = "marko-test"
  image_tag_mutability = "MUTABLE"
}

module "alb" {
  source = "../../../modules/alb"

  name     = "marko-test"
  internal = false
  vpc_id   = module.vpc.vpc_id
  subnets  = module.vpc.public_subnet_ids

  tags = {
    Name = "marko-alb-test"
    Env  = "staging"
  }
}

module "ecs" {
  source = "../../../modules/ecs"

  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnet_ids
  security_groups    = [module.alb.sg_id]
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  image_name         = module.ecr.repository_url
  desired_count      = 5
  target_group_arn   = module.alb.target_arn

  tags = {
    Name = "marko-ecs-test"
    Env  = "staging"
  }
}
