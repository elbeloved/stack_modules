locals {
  ServerPrefix = ""
}

resource "aws_instance" "server" {
  count                   = var.stack_controls["ec2_create"] == "Y" ? 1 : 0
  ami                     = var.ami_id
  instance_type           = var.EC2_Components["instance_type"]
  vpc_security_group_ids  = var.security_group_id
  user_data               = file(var.user_data_filepath)
  key_name                = var.PATH_TO_PUBLIC_KEY
  subnet_id               = var.subnet_ids[0]    
 root_block_device {
    volume_type           = var.EC2_Components["volume_type"]
    volume_size           = var.EC2_Components["volume_size"]
    delete_on_termination = var.EC2_Components["delete_on_termination"]
    encrypted             = var.EC2_Components["encrypted"] 
  }
  
  tags = merge({Name  = "${local.ServerPrefix != "" ? local.ServerPrefix : "Application_Server_Aut"}"}, var.required_tags)
 
}
