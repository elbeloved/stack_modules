variable "project" {}
  
variable "required_tags" {}

variable "subnet_ids" {}

variable "security_group_id" {
    type    = list(string)
    default = [ ]
}