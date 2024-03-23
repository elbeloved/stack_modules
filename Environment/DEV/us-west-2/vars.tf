variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {}

variable "Environment" {
  default = "dev"
}

variable "default_vpc_id" {
  default = "vpc-01e91717844ec6c82"
}

variable "System" {
  default = "Retail Reporting"
}

variable "subsystem" {
  default = "CliXX"
}

variable "availability_zone" {
  default = "us-west-2c"
}

variable "subnets_cidrs" {
  type = list(string)
  default = [
    "172.31.80.0/20"
  ]
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "my_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "my_key.pub"
}

variable "OwnerEmail" {
  default = "ayanfeafelumo@gmail.com"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-stack-1.0"
    us-west-2 = "ami-0c395fa9548070ecc"
    eu-west-1 = "ami-844e0bf7"
  }
}

variable "subnet" {
  default = "subnet-0351fc8a829ce7d51"
}

variable "subnet_ids" {
  type = list(string)
  default = [ 
    "subnet-0351fc8a829ce7d51",
    "subnet-03994451f0465ea81",
    "subnet-07da929a600c03545",
    "subnet-0fadc47462f995798"
    ]
}

variable "stack_controls" {
  type = map(string)
  default = {
    ec2_create = "Y"
    rds_create = "Y"
  }
}

variable "EC2_Components" {
  type = map(string)
  default = {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
    encrypted             = "true"
    instance_type         = "t2.micro"
  }
}

variable "ASG_Components" {
  type = map(string)
  default = {
    max_size                  = 4
    min_size                  = 2
    desired_capacity          = 2
    health_check_grace_period = 30
    health_check_type         = "EC2"
  }
}

variable "LTG_Components" {
  type = map(string)
  default = {
    port                = 80
    protocol            = "HTTP"
    matcher             = 200
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

variable "Backup" {
  default = "yes"
}

variable "project" {
  default = "Blog"
}

variable "resource_tags"{
description="Tags required to be specified on all resources"
type=object({})
}

variable "db_name" {
  description = "database name"
  type        = string
  default     = null
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
  default     = null
}

variable "access_ports" {
  type    = list(number)
  default = [80, 22, 3306, 2049] # 22 -> ssh, 80 -> http, 3306 -> Aurora/MySQL, 2049 -> EFS mount
}

variable "user_data_filepath" {
  type    = string
  default = "./scripts/bootstrap.tpl"
}