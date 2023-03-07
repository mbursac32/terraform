variable "name" {
  type    = string
  default = "lb"
}

variable "internal" {
  type    = bool
  default = false
}

variable "load_balancer_type" {
  type    = string
  default = "application"
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnets" {
  type    = list(any)
  default = []
}

variable "tags" {
  description = "Tags for the ALB"
  type        = map(string)
  default     = {}
}