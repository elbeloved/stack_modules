variable "project" {
  default     = "Clixx"
}

variable "db_group_subnet_ids" {
  description = "db_group_subnet_ids list"
  type        = list(string)
  default     = []
}

variable "instance_class" {
  description = "instance_class"
  type        = string
  default     = "db.t2.micro"
}

variable "skip_final_snapshot" {
  description = "skip_final_snapshot"
  type        = bool
  default     = true
}

variable "most_recent" {
  description = "most recent snapshot"
  type        = bool
  default     = null
}

variable "snapshot_identifier" {
  description = "db snapshot name"
  type        = string
  default     = null
}

variable "snapshot_type" {
  type        = string
  default     = "shared"
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

variable "required_tags"{
description="Tags required to be specified on all resources"
type=object({})
}

