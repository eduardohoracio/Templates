variable "name" {
  description = "Prefix name for all resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets (2 values)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets (3 values)"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones to use (minimum 3)"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "aws_region" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "multi_az" {
  type    = bool
  default = true
}

variable "kms_key_id" {
  type = string
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "deletion_protection" {
  type    = bool
  default = true
}

variable "monitoring_interval" {
  type    = number
  default = 60
}

variable "iam_authentication_enabled" {
  type    = bool
  default = true
}

variable "performance_insights_enabled" {
  type    = bool
  default = true
}

variable "performance_insights_retention_period" {
  type    = number
  default = 7
}

variable "apply_immediately" {
  type    = bool
  default = false
}

variable "common_tags" {
  type = map(string)
}

variable "log_bucket_name" {
  type = string
}
  
variable "aws_region" {
  type = string
}

variable "function_name" {
  type = string
}

variable "filename" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "memory_size" {
  type = number
  default = 128
}

variable "timeout" {
  type = number
  default = 10
}

variable "environment_variables" {
  type = map(string)
  default = {}
}

variable "kms_key_arn" {
  type = string
  default = null
}

variable "subnet_ids" {
  type = list(string)
  default = []
}

variable "security_group_ids" {
  type = list(string)
  default = []
}

variable "dead_letter_queue_arn" {
  type = string
  default = null
}

variable "tracing_mode" {
  type = string
  default = "PassThrough"
}

variable "log_retention_days" {
  type = number
  default = 14
}

variable "common_tags" {
  type = map(string)
}
