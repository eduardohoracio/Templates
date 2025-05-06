variable "function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable "filename" {
  description = "Path to the deployment package."
  type        = string
}

variable "handler" {
  description = "Lambda function entry point (e.g., index.handler)."
  type        = string
}

variable "runtime" {
  description = "Lambda runtime (e.g., nodejs18.x, python3.11)."
  type        = string
}

variable "memory_size" {
  description = "Amount of memory in MB."
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Function execution timeout in seconds."
  type        = number
  default     = 10
}

variable "environment_variables" {
  description = "Map of environment variables."
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "KMS Key ARN for encrypting environment variables and logs."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs for VPC access."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs for VPC access."
  type        = list(string)
  default     = []
}

variable "dead_letter_queue_arn" {
  description = "ARN of the SQS queue or SNS topic for failed executions."
  type        = string
  default     = null
}

variable "tracing_mode" {
  description = "Tracing mode for AWS X-Ray (Active | PassThrough | Disabled)."
  type        = string
  default     = "PassThrough"
}

variable "log_retention_days" {
  description = "Retention period for Lambda logs."
  type        = number
  default     = 365
}

variable "common_tags" {
  description = "Tags to apply to resources."
  type        = map(string)
}

variable "kms_key_id" {
    description = "KMS Key ARN for encrypting environment variables and logs."
    type        = string
    default     = null
  
}