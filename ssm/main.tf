#Create a random generated password to use in Secrets
resource "random_password" "random_secrets" {
  length           = 16
  special          = true
  min_special      = 5
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "cia_lab_secret" {
  name      = var.ssm_name
  type      = var.ssm_type
  value     = random_password.random_secrets.result
  //key_id    = var.kms_key_id
  tier      = var.ssm_tier
  data_type = var.data_type
  tags = {
    Name = "ssm_param_store_cia_lab"
  }
  lifecycle {
    ignore_changes = [
      insecure_value, value
    ]
  }
}
