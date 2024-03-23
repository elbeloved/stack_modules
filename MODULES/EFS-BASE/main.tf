locals {
  ServerPrefix = ""
}

resource "aws_efs_file_system" "efs" {
    creation_token = "${var.project}-efs"
   
     tags = merge({Name  = "${local.ServerPrefix != "" ? local.ServerPrefix : "CliXX_File_System"}"}, var.required_tags)
}

resource "aws_efs_mount_target" "mount" {
    count            =  length(var.subnet_ids)
    file_system_id   =  aws_efs_file_system.efs.id
    subnet_id        =  var.subnet_ids[count.index]
    security_groups  =  var.security_group_id
}