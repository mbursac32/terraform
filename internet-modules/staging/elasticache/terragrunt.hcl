include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///cloudposse/elasticache-redis/aws?version=0.49.0"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name                       = "marko-test-ec"
  availability_zones         = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc_id                     = dependency.vpc.outputs.vpc_id
  allowed_security_group_ids = [dependency.vpc.outputs.default_security_group_id]
  subnets                    = dependency.vpc.outputs.elasticache_subnets
  description                = "Test cluster"
  replication_group_id       = "marko-test-ec"
  cluster_size               = 1
  instance_type              = "cache.m6g.large"
  apply_immediately          = true
  automatic_failover_enabled = false
  engine_version             = "6.x"
  family                     = "redis6.x"
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  parameter = [
    {
      name  = "notify-keyspace-events"
      value = "lK"
    }
  ]

}

dependencies {
  paths = ["../vpc"]
}