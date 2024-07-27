resource "aws_security_group" "fsxn" {
  name        = "aws_cia_lab_FSxOnTap_FS"
  description = "Security group for aws cia lab FSxOnTap FS specific ports"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.fsxn_ingress_rules
    content {
      description = ingress.value["description"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidrs"]
    }
  }

  ingress {
    description = "Self referencing rule"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
  }

  dynamic "egress" {
    for_each = var.fsxn_egress_rules
    content {
      description = egress.value["description"]
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidrs"]
    }
  }
}
