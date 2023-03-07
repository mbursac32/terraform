variable "image_tag_mutability" {
  type = string
}

variable "name" {
  type        = string
  description = "name of the ECR repo"
}

variable "force_delete" {
  type    = bool
  default = true
}