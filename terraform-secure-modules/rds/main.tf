resource "aws_db_instance" "secure_rds" {
  allocated_storage    = var.allocated_storage
  enabled_cloudwatch_logs_exports = [ "general", "error", "slowquery" ]
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  db_name                 = var.db_name
  username             = var.username
  password             = var.password
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids

  multi_az             = var.multi_az
  publicly_accessible  = false
  storage_encrypted    = true
  kms_key_id           = var.kms_key_id
  backup_retention_period = var.backup_retention_period
  deletion_protection  = var.deletion_protection
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot = true
  monitoring_interval  = var.monitoring_interval
  iam_database_authentication_enabled = var.iam_authentication_enabled

  performance_insights_enabled = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  apply_immediately = var.apply_immediately

  tags = var.common_tags
}
