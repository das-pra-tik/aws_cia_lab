variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "deployment_type" {
  type = string
}

variable "storage_type" {
  type = string
}

variable "storage_capacity" {
  type = number
}

variable "throughput_capacity" {
  type = number
}

variable "kms_key_id" {
  type = string
}

variable "fsx_admin_password" {
  type = string
}

variable "svm_names" {
  type = list(string)
}

variable "svm_admin_password" {
  type = string
}

variable "dns_ips" {
  type = list(string)
}

variable "domain_name" {
  type = string
}

variable "domain_password" {
  type = string
}
variable "fsxn_ingress_rules" {
  type = map(any)
}

variable "fsxn_egress_rules" {
  type = map(any)
}

