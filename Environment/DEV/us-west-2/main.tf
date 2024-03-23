locals {
  ServerPrefix = ""
}

module "CORE-INFO" {
  source            = "../../../MODULES/CORE-INFO"
  required_tags     = {
    Environment     = var.Environment,
    OwnerEmail      = var.OwnerEmail,
    System          = var.System,
    Backup          = var.Backup,
    Region          = var.AWS_REGION
  }
}

module "EC2-BASE" {
  count             = var.stack_controls["ec2_create"] == "Y" ? 1 : 0
  source            = "../../../MODULES/EC2-BASE"
  ami_id            = data.aws_ami.stack_ami.id
  stack_controls    = var.stack_controls
  EC2_Components    = var.EC2_Components
  default_vpc_id    = var.default_vpc_id
  env               = var.Environment
  subnet_ids        = var.subnet_ids
  project           = var.project
  security_group_id = module.SECURITY-BASE[*].security_group_stack
  required_tags     = module.CORE-INFO.all_resource_tags
}

module "ASG-BASE" {
  count             = var.stack_controls["asg_create"] == "Y" ? 1 : 0 
  source            = "../../../MODULES/ASG-BASE"
  ami_id            = data.aws_ami.stack_ami
  stack_controls    = var.stack_controls
  EC2_Components    = var.EC2_Components
  default_vpc_id    = var.default_vpc_id
  env               = var.Environment
  subnet_ids        = var.subnet_ids
  ASG_Components    = var.ASG_Components
  project           = var.project
  LTG_Components    = var.LTG_Components
  security_group_id = module.SECURITY-BASE[*].security_group_stack
  required_tags     = module.CORE-INFO.all_resource_tags
}

module "RDS-BASE" {
  count                  = var.stack_controls["rds_create"] == "Y" ? 1 : 0 
  source                 = "../../../MODULES/RDS-BASE"
  snapshot_identifier    = var.snapshot_identifier
  instance_class         = var.instance_class
  skip_final_snapshot    = var.skip_final_snapshot
  required_tags          = module.CORE-INFO.all_resource_tags
  project                = var.project
}

module "SECURITY-BASE" {
  count                  = var.stack_controls["sg_create"] == "Y" ? 1 : 0
  source                 = "../../../MODULES/SECURITY-BASE"
  required_tags          = module.CORE-INFO.all_resource_tags
  access_ports           = var.access_ports
  default_vpc_id         = var.default_vpc_id
}

module "EFS-BASE" {
  count                  = var.stack_controls["efs_create"] == "Y" ? 1 : 0
  source                 = "../../../MODULES/EFS-BASE"
  project                = var.project
  subnet_ids             = var.subnet_ids
  security_group_id      = module.SECURITY-BASE[*].security_group_stack
  required_tags          = module.CORE-INFO.all_resource_tags
}