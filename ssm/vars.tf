variable "kms_key_id" {
  type = string
}

variable "ssm_prefix" {
  type = list(string)
}

variable "ssm_type" {
  description = "Type of the parameter. Valid types are String, StringList and SecureString."
  type        = string
}

variable "ssm_tier" {
  description = "Parameter tier to assign to the parameter. If not specified, will use the default parameter tier for the region. Valid tiers are Standard, Advanced, and Intelligent-Tiering. Downgrading an Advanced tier parameter to Standard will recreate the resource."
  type        = string
}



