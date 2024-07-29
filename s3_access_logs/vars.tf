variable "s3_access_logs_bucket" {
  type = string
}

variable "default_retention_noncurrent_days" {
  type = number
}

variable "archive_retention_noncurrent_days" {
  type = number
}

variable "kms_key_id" {
  type = string
}
