resource "aws_db_instance" "stack" {
    snapshot_identifier    = "${data.aws_db_snapshot.stack.id}"
    instance_class         = var.instance_class
    skip_final_snapshot    = var.skip_final_snapshot 
    vpc_security_group_ids = var.subnet_ids
    tags                   = merge({Name  = "${var.project}-dbname", }, var.required_tags)
}

data "aws_db_snapshot" "stack" {
    db_snapshot_identifier = var.snapshot_identifier
    most_recent            = var.most_recent
    snapshot_type          = var.snapshot_type
    include_shared         = true
}

