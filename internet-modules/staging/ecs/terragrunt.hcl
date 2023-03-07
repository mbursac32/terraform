include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-aws-modules/ecs/aws?version=4.1.3"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "asg" {
  config_path = "../asg"
  mock_outputs = {
    autoscaling_group_arn  = "arn:aws:autoscaling:eu-west-1:111111111111:autoScalingGroup:ce1dbda2-e91b-43db-8690-a575efbbc6cc:autoScalingGroupName/mock"
  }
}

inputs = {
  
  cluster_name = "marko-ecs-test"
  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        # You can set a simple string and ECS will create the CloudWatch log group for you
        # or you can create the resource yourself as shown here to better manage retetion, tagging, etc.
        # Embedding it into the module is not trivial and therefore it is externalized
        cloud_watch_log_group_name = "marko-ecs-cloudwatch"
      }
    }
  }

  autoscaling_capacity_providers = {
    test = {
      auto_scaling_group_arn         = dependency.asg.outputs.autoscaling_group_arn
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 5
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 60
      }

      default_capacity_provider_strategy = {
        weight = 60
        base   = 20
      }
    }
  }

  tags = {
    Terraform = "true"
    Environment = "staging"
  }


}

dependencies {
  paths = ["../vpc"]
}