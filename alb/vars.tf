variable "vpc_id" { type = string }
variable "alb_sec_groups" { type = list(string) }
variable "alb_public_subnets" { type = list(string) }
variable "alb_target_ids" { type = list(string) }
variable "alb_name" { type = string }
variable "alb_tg_name" { type = string }
variable "acm_cert_arn" { type = string }
variable "domain_name" { type = string }
