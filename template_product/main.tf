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
    bucket_name = "XXXXXXXXXXXXXXXXXXXXXXXX"
  
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