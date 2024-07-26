variable "msad_vpc_id" {
  type = string
}

variable "msad_subnet_ids" {
  type = list(string)
}

variable "ssm_param_name" {
  type = string
}

variable "ad-pwd" {
  type = string
}
