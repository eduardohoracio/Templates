variable "bucket_name" {
  description = "The name of the secure S3 bucket"
  type        = string
}

variable "log_bucket_name" {
  description = "The name of the S3 bucket to store access logs"
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
}
