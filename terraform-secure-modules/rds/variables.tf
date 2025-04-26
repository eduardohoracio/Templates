variable "allocated_storage" {
  description = "The allocated storage in gigabytes."
  type        = number
}

variable "engine" {
  description = "The database engine to use (e.g., mysql, postgres)."
  type        = string
}

variable "engine_version" {
  description = "The engine version to use."
  type        = string
}

variable "instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
}

variable "db_name" {
  description = "The name of the database to create."
  type        = string
}

variable "username" {
  description = "Username for the master DB user."
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Password for the master DB user."
  type        = string
  sensitive   = true
}

variable "db_subnet_group_name" {
  description = "Subnet group for the RDS instance."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate."
  type        = list(string)
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ."
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS Key ID for storage encryption."
  type        = string
}

variable "backup_retention_period" {
  description = "Number of days to retain backups."
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled."
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "Interval (seconds) for enhanced monitoring."
  type        = number
  default     = 60
}

variable "iam_authentication_enabled" {
  description = "Enable IAM authentication."
  type        = bool
  default     = true
}

variable "performance_insights_enabled" {
  description = "Enable Performance Insights."
  type        = bool
  default     = true
}

variable "performance_insights_retention_period" {
  description = "Retention period for Performance Insights (7 or 731 days)."
  type        = number
  default     = 7
}

variable "apply_immediately" {
  description = "Whether to apply changes immediately or during maintenance window."
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Common tags to apply to resources."
  type        = map(string)
}
