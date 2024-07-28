locals {
  internal_dns_zone = "cia-lab.local"
  ad_domain         = "cia-lab.aws"
}

resource "aws_directory_service_directory" "cia-lab-msad" {
  name = local.ad_domain
  //password = data.aws_ssm_parameter.ad-pwd.value
  password = var.ad-pwd
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = var.msad_vpc_id
    subnet_ids = var.msad_subnet_ids
  }
}

/*
resource "aws_route53_zone" "vpc" {
  name = local.internal_dns_zone

  vpc {
    vpc_id = var.msad_vpc_id
  }
}


resource "aws_route53_resolver_endpoint" "ad_hcm_resolver" {
  direction          = "OUTBOUND"
  security_group_ids = var.r53_resolver_endpoint_sg_ids
  ip_address {
    subnet_id = var.msad_subnet_ids[0]
  }
  ip_address {
    subnet_id = var.msad_subnet_ids[1]
  }
}

resource "aws_route53_resolver_rule" "ad_fwd" {
  domain_name          = local.ad_domain
  name                 = "ad_hcm_forward"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.ad_hcm_resolver.id

  target_ip { ip = sort(aws_directory_service_directory.cia-lab-msad.dns_ip_addresses)[0] }
  target_ip { ip = sort(aws_directory_service_directory.cia-lab-msad.dns_ip_addresses)[1] }
}

resource "aws_route53_resolver_rule_association" "ad_fwd" {
  resolver_rule_id = aws_route53_resolver_rule.ad_fwd.id
  vpc_id           = var.msad_vpc_id
}
*/
