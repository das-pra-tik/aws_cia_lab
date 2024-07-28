variable "db_subnet_group_name" {
  type = string
}
variable "db_subnet_ids" {
  type = list(string)
}
variable "db_instance_class" {
  type = string
}
variable "auto_minor_version_upgrade" {
  type = bool
}
variable "db_name" {
  type = string
}
variable "db_username" {
  type = string
}
variable "db_secrets" {
  type = string
}
variable "db_port" {
  type = string
}
variable "db_engine" {
  type = string
}
variable "db_engine_version" {
  type = string
}
variable "enable_multi_az" {
  type = bool
}
variable "kms_key_id" {
  type = string
}
variable "db_storage_type" {
  type = string
}
variable "db_allocated_storage" {
  type = number
}
variable "max_allocated_storage" {
  type = number
}
variable "maintenance_window" {
  type = string
}
variable "db_backup_window" {
  type = string
}
variable "db_backup_retention_period" {
  type = number
}
variable "db_sec_grp_ids" {
  type = list(string)
}
variable "enable_skip_final_snapshot" {
  type = bool
}
variable "is_public_access" {
  type = bool
}
variable "apply_immediately" {
  type = bool
}
variable "enabled_cloudwatch_logs_exports" {
  type = bool
}
variable "performance_insights_enabled" {
  type = bool
}
variable "performance_insights_retention_period" {
  type = number
}
