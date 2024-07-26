resource "aws_ec2_transit_gateway" "cia_lab_tgw" {
  description                     = "AWS CIA labs transit gateway"
  amazon_side_asn                 = var.amzn_side_asn
  dns_support                     = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments  = "enable"
  tags = {
    Name = "TGW_CIA_Lab"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_lamp-app-vpc" {
  subnet_ids                                      = var.lamp-app-vpc-private-subnet-ids
  transit_gateway_id                              = aws_ec2_transit_gateway.cia_lab_tgw.id
  vpc_id                                          = var.lamp-app-vpc-id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "TGA-lamp-app-vpc"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_shared-vpc" {
  subnet_ids                                      = var.shared-vpc-private-subnet-ids
  transit_gateway_id                              = aws_ec2_transit_gateway.cia_lab_tgw.id
  vpc_id                                          = var.shared-vpc-id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "TGA-shared-vpc"
  }
}

resource "aws_ec2_transit_gateway_route_table" "tgw_rtb_lamp-app-vpc" {
  depends_on         = [aws_ec2_transit_gateway.cia_lab_tgw, aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_lamp-app-vpc]
  transit_gateway_id = aws_ec2_transit_gateway.cia_lab_tgw.id

  tags = {
    "name" = "TGW_RTB_lamp-app-vpc"
  }
}

resource "aws_ec2_transit_gateway_route" "tgw_rtb_lamp-app-vpc_route" {
  depends_on                     = [aws_ec2_transit_gateway.cia_lab_tgw, aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_lamp-app-vpc, aws_ec2_transit_gateway_route_table.tgw_rtb_lamp-app-vpc]
  destination_cidr_block         = var.shared-vpc-cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_lamp-app-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rtb_lamp-app-vpc.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_rtb_lamp-app-vpc_association" {
  depends_on                     = [aws_ec2_transit_gateway_route.tgw_rtb_lamp-app-vpc_route, aws_ec2_transit_gateway_route_table.tgw_rtb_lamp-app-vpc]
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_lamp-app-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rtb_lamp-app-vpc.id
}


resource "aws_ec2_transit_gateway_route_table" "tgw_rtb_shared-vpc" {
  depends_on         = [aws_ec2_transit_gateway.cia_lab_tgw, aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_shared-vpc]
  transit_gateway_id = aws_ec2_transit_gateway.cia_lab_tgw.id

  tags = {
    "name" = "TGW_RTB_shared-vpc"
  }
}

resource "aws_ec2_transit_gateway_route" "tgw_rtb_shared-vpc_route" {
  depends_on                     = [aws_ec2_transit_gateway.cia_lab_tgw, aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_shared-vpc, aws_ec2_transit_gateway_route_table.tgw_rtb_shared-vpc]
  destination_cidr_block         = var.lamp-app-vpc-cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_shared-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rtb_shared-vpc.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_rtb_shared-vpc_association" {
  depends_on                     = [aws_ec2_transit_gateway_route_table.tgw_rtb_shared-vpc, aws_ec2_transit_gateway_route.tgw_rtb_shared-vpc_route]
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_shared-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rtb_shared-vpc.id
}
