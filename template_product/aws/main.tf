terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
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