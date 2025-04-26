resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.function_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "secure_lambda" {
  function_name = var.function_name
  filename      = var.filename
  handler       = var.handler
  runtime       = var.runtime
  role          = aws_iam_role.lambda_exec_role.arn
  memory_size   = var.memory_size
  timeout       = var.timeout
  code_signing_config_arn = aws_lambda_code_signing_config.code_sign.arn

  environment {
    variables = var.environment_variables
  }

  dead_letter_config {
    target_arn = var.dead_letter_queue_arn
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  tracing_config {
    mode = var.tracing_mode
  }

  kms_key_arn = var.kms_key_arn
  publish = true

  tags = var.common_tags
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.secure_lambda.function_name}"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_id

  tags = var.common_tags
}

resource "aws_lambda_code_signing_config" "code_sign" {
  allowed_publishers {
    signing_profile_version_arns = [aws_signer_signing_profile.example.version_arn]
  }

  policies {
    untrusted_artifact_on_deployment = "Enforce"
  }
}