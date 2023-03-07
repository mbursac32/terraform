variable "sg_name" {
  type        = string
  default     = "ecs-container-sg"
}

variable "vpc_id" {
  type        = string
  default     = ""
}

variable "security_groups" {
  type        = list
  default     = []
}

variable "tags" {
  description = "Tags for the ECS components"
  type        = map(string)
  default     = {}
}

variable "cluster_name" {
  type        = string
  default     = "marko-ecs-test"
}

variable "family" {
  type        = string
  default     = "marko-task-definition"
}

variable "execution_role_arn" {
  type        = string
  default     = ""
}

variable "task_definition_name" {
  type        = string
  default     = "marko-task-definition"
}

variable "image_name" {
  type        = string
  default     = ""
}

variable "essential" {
  type        = bool
  default     = false
}

variable "containerPort" {
  type        = number
  default     = 3000
}

variable "requires_compatibilities" {
  type        = list
  default     = ["EC2"]
}

variable "service_name" {
  type        = string
  default     = "marko-test-service"
}

variable "desired_count" {
  type        = number
  default     = 2
}

variable "launch_type" {
  type        = string
  default     = "EC2"
}

variable "target_group_arn" {
  type        = string
  default     = ""
}

variable "subnets" {
  type        = list
  default     = []
}