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
  region = "us-east-1"
  profile = "default"
}

module "vpc" {
    source = "./vpc"
    vpc_cidr = "10.0.0.0/16"
    vpc_name = "Terraform VPC"
    subnet_cidr = "10.0.1.0/24"
    subnet_name = "Terraform Subnet"
  
}

module "s3" {
    source = "./s3"
    bucket_name = var.log_bucket_name
  
}

module "ec2" {
    source = "./ec2"
    ec2_name = "Terraform EC2"
    ec2_type = "t2.micro"
    subnet_id = module.vpc.subnet_id
  
}

module "rds" {
    source = "./rds"
    rds_name = "Terraform RDS"
    rds_username = "XXXXX"
    rds_password = "XXXXXXXX"
    rds_instance_class = "db.t2.micro"
    subnet_ids = module.vpc.subnet_ids
  
}
module "eks" {
    source = "./eks"
    eks_name = "Terraform EKS"
    subnet_ids = module.vpc.subnet_ids
  
}

module "lambda" {
    source = "./lambda"
    lambda_name = "Terraform Lambda"
    lambda_role = "XXXXXXXXXXXXXXXXXXXXXXXX"
    lambda_arn = "XXXXXXXXXXXXXXXXXXXXXXXX"
  
}

module "apigateway" {
    source = "./apigateway"
    api_name = "Terraform API Gateway"
    api_stage_name = "dev"
  
}

module "secure_rds" {
  source = "./modules/rds_secure_instance"

  allocated_storage              = var.allocated_storage
  engine                         = var.engine
  engine_version                 = var.engine_version
  instance_class                 = var.instance_class
  db_name                        = var.db_name
  username                       = var.username
  password                       = var.password
  db_subnet_group_name           = var.db_subnet_group_name
  vpc_security_group_ids         = var.vpc_security_group_ids
  multi_az                       = var.multi_az
  kms_key_id                     = var.kms_key_id
  backup_retention_period        = var.backup_retention_period
  deletion_protection            = var.deletion_protection
  monitoring_interval            = var.monitoring_interval
  iam_authentication_enabled     = var.iam_authentication_enabled
  performance_insights_enabled   = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  apply_immediately              = var.apply_immediately
  common_tags                    = var.common_tags
}

module "secure_s3" {
  source          = "./modules/s3_secure_bucket"
  bucket_name     = var.bucket_name
  log_bucket_name = aws_s3_bucket.log_bucket.bucket
  common_tags     = var.common_tags
}

provider "aws" {
  region = var.aws_region
}

module "secure_lambda" {
  source                  = "./modules/lambda_secure_function"
  function_name           = var.function_name
  filename                = var.filename
  handler                 = var.handler
  runtime                 = var.runtime
  memory_size             = var.memory_size
  timeout                 = var.timeout
  environment_variables   = var.environment_variables
  kms_key_arn             = var.kms_key_arn
  subnet_ids              = var.subnet_ids
  security_group_ids      = var.security_group_ids
  dead_letter_queue_arn   = var.dead_letter_queue_arn
  tracing_mode            = var.tracing_mode
  log_retention_days      = var.log_retention_days
  common_tags             = var.common_tags
}
