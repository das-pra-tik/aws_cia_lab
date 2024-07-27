module "aws_cia_lab_vpc" {
  source             = "./vpc"
  vpc-map            = var.vpc-map
  lamp-app-subnets   = var.lamp-app-subnets
  shared-vpc-subnets = var.shared-vpc-subnets
  lamp-app-vpc-cidr  = lookup(var.vpc-map, "lamp-app-vpc")
  shared-vpc-cidr    = lookup(var.vpc-map, "shared-vpc")
  tgw-id             = module.aws_cia_lab_tgw.tgw-id
}

module "aws_cia_lab_tgw" {
  source                          = "./tgw"
  amzn_side_asn                   = var.amzn_side_asn
  lamp-app-vpc-id                 = module.aws_cia_lab_vpc.lamp-app-vpc-id
  shared-vpc-id                   = module.aws_cia_lab_vpc.shared-vpc-id
  lamp-app-vpc-cidr               = module.aws_cia_lab_vpc.lamp-app-vpc-cidr
  shared-vpc-cidr                 = module.aws_cia_lab_vpc.shared-vpc-cidr
  lamp-app-vpc-private-subnet-ids = module.aws_cia_lab_vpc.lamp-app-vpc-private-subnet-ids
  shared-vpc-private-subnet-ids   = module.aws_cia_lab_vpc.shared-vpc-private-subnet-ids
  //lamp-app-vpc-public-subnet-ids  = module.aws_cia_vpc.lamp-app-vpc-public-subnet-ids
  //shared-vpc-public-subnet-ids    = module.aws_cia_vpc.shared-vpc-public-subnet-ids
}
/*
module "aws_cia_lab_kms" {
  source              = "./kms"
  kms_alias_name      = var.kms_alias_name
  kms_enabled         = var.kms_enabled
  kms_rotation        = var.kms_rotation
  kms_deletion_window = var.kms_deletion_window
  key_spec            = var.key_spec
}
*/
module "aws_cia_lab_ssm" {
  source     = "./ssm"
  ssm_prefix = var.ssm_prefix
  //ssm_value  = var.ssm_value
  ssm_type = var.ssm_type
  ssm_tier = var.ssm_tier
  //kms_key_id = module.aws_cia_lab_kms.kms-key-id
}

module "aws_cia_lab_msad" {
  source          = "./msad"
  ad-pwd          = module.aws_cia_lab_ssm.ssm_value
  msad_vpc_id     = module.aws_cia_lab_vpc.shared-vpc-id
  msad_subnet_ids = module.aws_cia_lab_vpc.shared-vpc-private-subnet-ids
}

module "aws_cia_lab_fsxn" {
  source              = "./fsxn"
  vpc_id              = module.aws_cia_lab_vpc.shared-vpc-id
  private_subnet_ids  = module.aws_cia_lab_vpc.shared-vpc-private-subnet-ids
  deployment_type     = var.deployment_type
  storage_type        = var.storage_type
  storage_capacity    = var.storage_capacity
  throughput_capacity = var.throughput_capacity
  svm_names           = var.svm_names
  dns_ips             = [module.aws_cia_lab_msad.dns_ip_addresses_1, module.aws_cia_lab_msad.dns_ip_addresses_2]
  domain_name         = module.aws_cia_lab_msad.domain_name
  fsxn_ingress_rules  = var.fsxn_ingress_rules
  fsxn_egress_rules   = var.fsxn_egress_rules
  domain_password     = module.aws_cia_lab_ssm.ssm_value
  fsx_admin_password  = module.aws_cia_lab_ssm.ssm_value
  svm_admin_password  = module.aws_cia_lab_ssm.ssm_value
}

module "aws_cia_lab_s3_website" {
  source         = "./s3_website"
  s3_bucket_name = var.s3_bucket_name
  cdn_arn        = module.aws_cia_lab_cdn.cdn_arn
}

module "aws_cia_lab_cdn" {
  source          = "./cdn"
  alt_domain_name = var.alt_domain_name
  domain_name     = module.aws_cia_lab_s3_website.s3_bucket_regional_domain_name
  acm_cert_arn    = module.aws_cia_lab_acm_r53.acm_certificate_arn
}

module "aws_cia_lab_acm_r53" {
  source                 = "./acm_r53"
  domain_name            = var.domain_name
  alt_domain_name        = var.alt_domain_name
  r53_cdn_hosted_zone_id = module.aws_cia_lab_cdn.cdn_hosted_zone_id
  r53_cdn_domain_name    = module.aws_cia_lab_cdn.cdn_domain_name
}
