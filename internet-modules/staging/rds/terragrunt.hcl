include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-aws-modules/rds/aws?version=5.6.0"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "rds-sg" {
  config_path = "../rds-sg"
}

inputs = {

  identifier                          = "marko"
  engine                              = "mysql"
  engine_version                      = "5.7"
  instance_class                      = "db.t3.small"
  allocated_storage                   = 5
  db_name                             = "test"
  username                            = "admin"
  port                                = "3306"
  iam_database_authentication_enabled = true
  skip_final_snapshot                 = true

  vpc_security_group_ids = [dependency.rds-sg.outputs.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Env = "staging"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = [dependency.vpc.outputs.public_subnets[0], dependency.vpc.outputs.public_subnets[1], dependency.vpc.outputs.public_subnets[2]]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}

dependencies {
  paths = ["../vpc", "../rds-sg"]
}