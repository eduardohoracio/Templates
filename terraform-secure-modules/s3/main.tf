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