variable "instance_type" { type = string }
variable "rsa_bits" { type = number }
variable "key_pair_name" { type = string }
variable "algorithm" { type = string }
variable "USER_DATA" { type = string }
variable "instance_sec_grp_ids" { type = list(string) }
variable "ec2_subnet_ids" { type = list(string) }
variable "root_vol_size" { type = number }
variable "vol_type" { type = string }
variable "kms_key_id" { type = string }

variable "lt_name" {
  type = string
}
variable "iops" {
  type = number
}
variable "throughput" {
  type = number
}
variable "data_vol_size" {
  type = number
}
variable "min_size" {
  type = number
}
variable "max_size" {
  type = number
}
variable "desired_size" {
  type = number
}
variable "asg_health_check_type" {
  type = string
}
variable "alb_target_group_arns" {
  type = list(string)
}
