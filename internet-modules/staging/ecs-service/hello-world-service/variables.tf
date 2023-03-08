variable "cluster_id" {
  description = "The ECS cluster ID"
  type        = string
}

variable "name_prefix" {
  type    = string
  default = "marko-test-"
}

variable "retention_in_days" {
  type    = number
  default = 1
}

variable "family" {
  type    = string
  default = "marko-test-task-definition"
}

variable "containerPort" {
  type    = number
  default = 80
}

variable "image" {
  type    = string
  default = "hello-world"
}

variable "cpu" {
  type    = number
  default = 10
}

variable "memory" {
  type    = number
  default = 128
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "service_name" {
  type    = string
  default = "marko-test-service"
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "container_port" {
  type    = number
  default = 80
}

variable "container_name" {
  type    = string
  default = "marko-ecs-container-name"
}

variable "target_group_arn" {
  type = string
}

variable "subnets" {
  type    = list(any)
  default = []
}

variable "security_groups" {
  type    = list(any)
  default = []
}