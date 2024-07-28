# Step1: Create DB Subnet Group
resource "aws_db_subnet_group" "db-subnet-grp" {
  name       = var.db_subnet_group_name
  subnet_ids = var.db_subnet_ids
}

# Step2: Create the PostgreSQL RDS database
resource "aws_db_instance" "rds_postgres" {
  instance_class                      = var.db_instance_class
  auto_minor_version_upgrade          = var.auto_minor_version_upgrade
  db_name                             = var.db_name
  username                            = var.db_username
  password                            = var.db_secrets
  port                                = var.db_port
  engine                              = var.db_engine
  engine_version                      = var.db_engine_version
  multi_az                            = var.enable_multi_az
  storage_type                        = var.db_storage_type
  storage_encrypted                   = true
  kms_key_id                          = var.kms_key_id
  allocated_storage                   = var.db_allocated_storage
  max_allocated_storage               = var.max_allocated_storage
  maintenance_window                  = var.maintenance_window
  backup_window                       = var.db_backup_window
  backup_retention_period             = var.db_backup_retention_period
  db_subnet_group_name                = aws_db_subnet_group.db-subnet-grp.name
  vpc_security_group_ids              = var.db_sec_grp_ids
  skip_final_snapshot                 = var.enable_skip_final_snapshot
  publicly_accessible                 = var.is_public_access
  apply_immediately                   = var.apply_immediately
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports ? ["postgresql", "upgrade"] : []
  iam_database_authentication_enabled = false

  # Performance Insights
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null

  lifecycle {
    ignore_changes = [password]
  }
}
