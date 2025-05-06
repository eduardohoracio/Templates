resource "aws_s3_bucket" "secure_bucket" {
  bucket = var.bucket_name

   tags = var.common_tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.secure_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
  
}

resource "aws_s3_bucket_server_side_encryption_configuration" "server_side_encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "life_configuration" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
    id     = "archive-and-expire"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      noncurrent_days = 365
    }
  }
  
}

resource "aws_s3_bucket_logging" "logging" {
  bucket = aws_s3_bucket.secure_bucket.id

  target_bucket = aws_s3_bucket.secure_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.secure_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

