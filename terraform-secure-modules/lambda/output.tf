output "lambda_function_name" {
  value = aws_lambda_function.secure_lambda.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.secure_lambda.arn
}

output "lambda_execution_role_arn" {
  value = aws_iam_role.lambda_exec_role.arn
}
