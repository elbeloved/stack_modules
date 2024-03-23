locals {
  ServerPrefix = ""
}

resource "aws_security_group" "stack" {
  name   = "${var.project}-sg"
  vpc_id = var.default_vpc_id

  dynamic "ingress" {
    for_each = var.access_ports
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      description      = "Allow all request from anywhere"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 

  }

  timeouts {
    delete = "2m"
  }

  lifecycle {
    create_before_destroy = true
  }

 tags = merge({Name  = "${local.ServerPrefix != "" ? local.ServerPrefix : "security_grp"}"}, var.required_tags)
}


