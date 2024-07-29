# Create a random generated password to use in Secrets
resource "random_password" "random_secrets" {
  //count            = length(var.ssm_prefix)
  length           = 20
  special          = true
  min_special      = 5
  override_special = "!#$%^&*()/@-_=+[]{}<>:?"
}

locals {
  ssm_secrets = {
    domain_secret = {
      name        = var.ssm_prefix[0]
      type        = var.ssm_type
      description = "Domain Authentication Password Secrets"
      key_id      = var.kms_key_id
      overwrite   = false
      tier        = var.ssm_tier
    }
    fsxn_secret = {
      name        = var.ssm_prefix[1]
      type        = var.ssm_type
      description = "fsxn Password Secrets"
      key_id      = var.kms_key_id
      overwrite   = false
      tier        = var.ssm_tier
    }
    svm_secret = {
      name        = var.ssm_prefix[2]
      type        = var.ssm_type
      description = "svm Password Secrets"
      key_id      = var.kms_key_id
      overwrite   = false
      tier        = var.ssm_tier
    }
    rds_secret = {
      name        = var.ssm_prefix[3]
      type        = var.ssm_type
      description = "PostgreSQL RDS Password Secrets"
      key_id      = var.kms_key_id
      overwrite   = false
      tier        = var.ssm_tier
    }
  }
}
resource "aws_ssm_parameter" "cia_lab_secret" {
  for_each    = local.ssm_secrets
  description = each.value.description
  name        = each.value.name
  value       = random_password.random_secrets.result
  type        = each.value.type
  tier        = each.value.tier
  key_id      = each.value.key_id
  tags = {
    Name = "ssm_param_store_cia_lab"
  }
  lifecycle {
    ignore_changes = [
      insecure_value, value
    ]
  }
}
