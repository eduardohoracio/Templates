provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["$HOME/.aws/config"]
  shared_credentials_files = ["$HOME/.aws/credentials"]
  profile                  = "my-access-profile"
}

# Lambda resource policy to prevent public access
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "DenyPublicInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.private_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.private_bucket.arn
}

# Create VPC for private access to Lambda
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create Subnets
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
}

# # Create Security Group
resource "aws_security_group" "lambda_sg" {
  name        = "lambda-security-group"
  description = "Security group for private Lambda access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Only allow internal traffic"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow Lambda to access the internet (outbound only)
    description = "Allow Internet traffic"
  }
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_role" {
  name = "lambda-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

# Attach the AWSLambdaVPCAccessExecutionRole Managed Policy to the Lambda Role
resource "aws_iam_role_policy_attachment" "vpc_access_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Create the Lambda Function code
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_payload.zip"

}

# Create private Bucket
resource "aws_s3_bucket" "private_bucket" {
  bucket = "private-bt-lambda-code-signed" # Replace with your desired bucket name
}

resource "aws_s3_bucket_versioning" "east" {
  bucket = aws_s3_bucket.private_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "west" {
  provider = aws.west
  bucket   = "tf-test-bucket-west-12345"
}

resource "aws_s3_bucket_versioning" "west" {
  provider = aws.west

  bucket = aws_s3_bucket.west.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "east_to_west" {
  depends_on = [aws_s3_bucket_versioning.east]
  role       = aws_iam_role.east_replication.arn
  bucket     = aws_s3_bucket.private_bucket.id

  rule {
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.west.arn
      storage_class = "STANDARD"
    }
  }
}

# Enable Bucket Versioning
resource "aws_s3_bucket_versioning" "private_bucket_versioning" {
  bucket = aws_s3_bucket.private_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable Server-Side Encryption (SSE) for the Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "private_bucket_sse_config" {
  bucket = aws_s3_bucket.private_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Disable Public Access Block for the Bucket
resource "aws_s3_bucket_public_access_block" "private_bucket_config" {
  bucket = aws_s3_bucket.private_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload the ZIP file to the S3 bucket
resource "aws_s3_object" "code_zip" {
  bucket      = aws_s3_bucket.private_bucket.id
  key         = "code/lambda_function_payload.zip" # Path within the S3 bucket
  source      = "lambda_function_payload.zip"      # Local path to the ZIP file
  source_hash = data.archive_file.lambda.output_base64sha256
  depends_on  = [aws_s3_bucket.private_bucket]
}

# Create a Signing Profile for AWS Signer
resource "aws_signer_signing_profile" "test_sp" {
  platform_id = "AWSLambda-SHA384-ECDSA"

  signature_validity_period {
    value = 12
    type  = "MONTHS"
  }
}

# Signing Job to Sign a File
resource "aws_signer_signing_job" "build_signing_job" {
  profile_name = aws_signer_signing_profile.test_sp.name

  source {
    s3 {
      bucket  = aws_s3_bucket.private_bucket.id
      key     = aws_s3_object.code_zip.id
      version = aws_s3_object.code_zip.version_id
    }
  }

  destination {
    s3 {
      bucket = aws_s3_bucket.private_bucket.id
      prefix = "signed/"
    }
  }

  ignore_signing_job_failure = false
}


# Create a Lambda Code Signing Configuration
resource "aws_lambda_code_signing_config" "lambda_signing_config" {
  allowed_publishers {
    signing_profile_version_arns = [
      aws_signer_signing_profile.test_sp.version_arn
    ]
  }

  policies {
    untrusted_artifact_on_deployment = "Enforce"
  }
}

# Lambda function inside VPC (not public)
resource "aws_lambda_function" "private_lambda" {
  function_name           = "private_lambda_function"
  runtime                 = "python3.9"
  handler                 = "lambda_function.lambda_handler"
  role                    = aws_iam_role.lambda_role.arn
  source_code_hash        = data.archive_file.lambda.output_base64sha256
  code_signing_config_arn = aws_lambda_code_signing_config.lambda_signing_config.arn

  # S3 for signer configurations
  s3_bucket = aws_signer_signing_job.build_signing_job.signed_object[0].s3[0].bucket
  s3_key    = aws_signer_signing_job.build_signing_job.signed_object[0].s3[0].key


  # Specify the VPC to prevent public access
  vpc_config {
    subnet_ids         = [aws_subnet.private_subnet.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      ENV = "development"
    }
  }
}

# No API Gateway or public exposure - use S3, DynamoDB, etc., instead
# Add IAM policy to allow access to internal AWS services (e.g., S3, DynamoDB)
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-access-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:PutObject"],
        Resource = ["arn:aws:s3:::private-bt-lambda-code-signed/*"]
      }
    ]
  })
}