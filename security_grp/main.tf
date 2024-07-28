resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id
  name   = "Dynamic_SG_EC2"
  dynamic "ingress" {
    for_each = var.ec2_ports
    iterator = port
    content {
      description = port.value.description
      from_port   = port.value.port
      to_port     = port.value.port
      protocol    = port.value.protocol
      //cidr_blocks     = port.value.cidr_blocks
      security_groups = [aws_security_group.alb_sg.id]
      self            = false
    }
  }
  dynamic "egress" {
    for_each = var.ec2_ports
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      self        = false
    }
  }
}

resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id
  name   = "Dynamic_SG-ALB"
  dynamic "ingress" {
    for_each = var.alb_ports
    iterator = port
    content {
      description = port.value.description
      from_port   = port.value.port
      to_port     = port.value.port
      protocol    = port.value.protocol
      cidr_blocks = port.value.cidr_blocks
      self        = false
    }
  }
  dynamic "egress" {
    for_each = var.alb_ports
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      self        = false
    }
  }
}
