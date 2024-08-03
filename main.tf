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

module "aws_cia_lab_kms" {
  source              = "./kms"
  kms_alias_name      = var.kms_alias_name
  kms_enabled         = var.kms_enabled
  kms_rotation        = var.kms_rotation
  kms_deletion_window = var.kms_deletion_window
  key_spec            = var.key_spec
}

module "aws_cia_lab_ssm" {
  source     = "./ssm"
  ssm_prefix = var.ssm_prefix
  ssm_type   = var.ssm_type
  ssm_tier   = var.ssm_tier
  kms_key_id = module.aws_cia_lab_kms.kms-key-arn
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
  kms_key_id          = module.aws_cia_lab_kms.kms-key-arn
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
  alt_domain_name = var.alt_domain_name_1
  domain_name     = module.aws_cia_lab_s3_website.s3_bucket_regional_domain_name
  acm_cert_arn    = module.aws_cia_lab_acm_r53.acm_certificate_arn
}

module "aws_cia_lab_acm_r53" {
  source                 = "./acm_r53"
  domain_name            = var.domain_name
  alt_domain_name_1      = var.alt_domain_name_1
  alt_domain_name_2      = var.alt_domain_name_2
  r53_cdn_hosted_zone_id = module.aws_cia_lab_cdn.cdn_hosted_zone_id
  r53_cdn_domain_name    = module.aws_cia_lab_cdn.cdn_domain_name
  r53_alb_hosted_zone_id = module.aws_cia_lab_alb.alb_zone_id
  r53_alb_domain_name    = module.aws_cia_lab_alb.alb_dns_endpoint
}
module "aws_cia_lab_alb" {
  source                = "./alb"
  vpc_id                = module.aws_cia_lab_vpc.lamp-app-vpc-id
  alb_public_subnets    = module.aws_cia_lab_vpc.lamp-app-vpc-public-subnet-ids
  alb_name              = var.alb_name
  s3_access_logs_bucket = module.aws_cia_lab_s3_access_logs.s3_access_logs_bucket_name
  alb_tg_name           = var.alb_tg_name
  domain_name           = var.domain_name
  //alb_target_ids        = module.aws_cia_lab_ec2.instance-ids
  alb_sec_groups = [module.aws_cia_lab_security_grp.alb-sg-ids]
  acm_cert_arn   = module.aws_cia_lab_acm_r53.acm_certificate_arn
  asg_name       = module.aws_cia_lab_ec2.asg_name
}

module "aws_cia_lab_ec2" {
  source                = "./ec2"
  algorithm             = var.algorithm
  rsa_bits              = var.rsa_bits
  key_pair_name         = var.key_pair_name
  instance_type         = var.instance_type
  root_vol_size         = var.root_vol_size
  vol_type              = var.root_vol_type
  kms_key_id            = module.aws_cia_lab_kms.kms-key-arn
  USER_DATA             = var.USER_DATA
  instance_sec_grp_ids  = [module.aws_cia_lab_security_grp.ec2-sg-ids]
  ec2_subnet_ids        = module.aws_cia_lab_vpc.lamp-app-vpc-private-subnet-ids
  lt_name               = var.lt_name
  iops                  = var.iops
  throughput            = var.throughput
  data_vol_size         = var.data_vol_size
  min_size              = var.min_size
  max_size              = var.max_size
  desired_size          = var.desired_size
  asg_health_check_type = var.asg_health_check_type
  alb_target_group_arns = [module.aws_cia_lab_alb.alb_tg_arn]
}

module "aws_cia_lab_security_grp" {
  source    = "./security_grp"
  vpc_id    = module.aws_cia_lab_vpc.lamp-app-vpc-id
  alb_ports = var.alb_ports
  ec2_ports = var.ec2_ports
  rds_ports = var.rds_ports
}

module "aws_cia_lab_postgresql" {
  source                                = "./postgresql"
  db_subnet_group_name                  = var.db_subnet_group_name
  db_subnet_ids                         = module.aws_cia_lab_vpc.lamp-app-vpc-database-subnet-ids
  db_sec_grp_ids                        = [module.aws_cia_lab_security_grp.db-sg-ids]
  db_instance_class                     = var.db_instance_class
  db_engine                             = var.db_engine
  db_engine_version                     = var.db_engine_version
  db_name                               = var.db_name
  kms_key_id                            = module.aws_cia_lab_kms.kms-key-arn
  db_storage_type                       = var.db_storage_type
  db_allocated_storage                  = var.db_allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  maintenance_window                    = var.maintenance_window
  db_backup_window                      = var.db_backup_window
  db_backup_retention_period            = var.db_backup_retention_period
  db_port                               = var.db_port
  enable_skip_final_snapshot            = var.enable_skip_final_snapshot
  is_public_access                      = var.is_public_access
  enable_multi_az                       = var.enable_multi_az
  db_username                           = var.db_username
  db_secrets                            = module.aws_cia_lab_ssm.ssm_value
  apply_immediately                     = var.apply_immediately
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
}

module "aws_cia_lab_s3_access_logs" {
  source                            = "./s3_access_logs"
  kms_key_id                        = module.aws_cia_lab_kms.kms-key-arn
  s3_access_logs_bucket             = var.s3_access_logs_bucket
  default_retention_noncurrent_days = var.default_retention_noncurrent_days
  archive_retention_noncurrent_days = var.archive_retention_noncurrent_days
}
