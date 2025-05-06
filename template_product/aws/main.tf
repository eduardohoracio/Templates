terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  profile = "default"
}

module "vpc" {
    source = "../../terraform-secure-modules/aws/vpc"
    name = var.name
    vpc_cidr = var.vpc_cidr
    availability_zones = var.availability_zones
    private_subnet_cidrs = var.private_subnet_cidrs
    public_subnet_cidrs = var.public_subnet_cidrs

  
}

module "s3" {
    source = "../../terraform-secure-modules/aws/s3"
    log_bucket_name = var.log_bucket_name
    bucket_name = var.log_bucket_name
    common_tags = var.common_tags
  
}

module "ec2" {
    source = "../../terraform-secure-modules/aws/ec2"
  
}

module "rds" {
    source = "../../terraform-secure-modules/aws/rds"
    db_name = var.db_name
    vpc_security_group_ids = var.vpc_security_group_ids
    username = var.username
    password = var.password
    engine = var.engine
    engine_version = var.engine_version
    instance_class = var.instance_class
    allocated_storage = var.allocated_storage
    db_subnet_group_name = var.db_subnet_group_name
    apply_immediately = var.apply_immediately
    kms_key_id = var.kms_key_id
    common_tags = var.common_tags
    multi_az = var.multi_az
    backup_retention_period = var.backup_retention_period
    deletion_protection = var.deletion_protection
    monitoring_interval = var.monitoring_interval
    iam_authentication_enabled = var.iam_authentication_enabled
    performance_insights_enabled = var.performance_insights_enabled
    performance_insights_retention_period = var.performance_insights_retention_period

  
}
module "eks" {
    source = "../../terraform-secure-modules/aws/eks"
  
}

module "lambda" {
    source = "../../terraform-secure-modules/aws/lambda"
    function_name = var.function_name
    filename = var.filename
    handler = var.handler
    runtime = var.runtime
    memory_size = var.memory_size
    timeout = var.timeout
    environment_variables = var.environment_variables
    kms_key_arn = var.kms_key_arn
    subnet_ids = var.subnet_ids
    common_tags = var.common_tags
  
}

module "apigateway" {
    source = "../../terraform-secure-modules/aws/apigateway"
  
}