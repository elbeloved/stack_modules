variable "project" {
  description = "security group name"
  type        = string
  default     = "CliXX"
}

variable "access_ports" {
  type    = list(number)
  default = [ ] 
}

variable "required_tags"{
description="Tags required to be specified on all resources"
type=object({})
}

variable "default_vpc_id" {}
