################################################################################
# SSM Parameter
################################################################################
variable "ssm_name" {
  description = "Name of SSM parameter"
  type        = string
}

variable "ssm_type" {
  description = "Type of the parameter. Valid types are String, StringList and SecureString."
  type        = string
}

variable "ssm_tier" {
  description = "Parameter tier to assign to the parameter. If not specified, will use the default parameter tier for the region. Valid tiers are Standard, Advanced, and Intelligent-Tiering. Downgrading an Advanced tier parameter to Standard will recreate the resource."
  type        = string
}

variable "data_type" {
  description = "Data type of the parameter. Valid values: text, aws:ssm:integration and aws:ec2:image for AMI format."
  type        = string
}
/*
variable "kms_key_id" {
  type = string
}
*/