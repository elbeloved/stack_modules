variable "ami_id"{}

variable "default_vpc_id" {}

variable "env" {}

variable "project" {
  default = "Clixx"
}

# variable "PATH_TO_PRIVATE_KEY" {
#   default = "my_key"
# }

# variable "PATH_TO_PUBLIC_KEY" {
#   default = "my_key.pub"
# }

variable "subnet_ids" {
  type = list(string)
  default = []
}

variable "stack_controls" {
  type = map(string)
  default = {}
}

variable "EC2_Components" {
  type = map(string)
  default = {}
}

variable "ASG_Components" {
  type = map(string)
  default = {}
}

variable "LTG_Components" {
  type = map(string)
  default = {}
}

variable "required_tags"{
  description="Tags required to be specified on all resources"
  type=object({})
}

variable "security_group_id" {
  type    = list(string)
  default = [ ]
}

variable "user_data_filepath" {
  type    = string
  default = "./scripts/bootstrap.tpl"
}

