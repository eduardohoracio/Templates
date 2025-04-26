aws_region         = "us-east-1"
allocated_storage  = 20
engine             = "postgres"
engine_version     = "15.2"
instance_class     = "db.t3.micro"
db_name            = "mysecuredatabase"
username           = "adminuser"
password           = "SuperSecretPassword123!"
db_subnet_group_name = "my-db-subnet-group"
vpc_security_group_ids = ["sg-0123456789abcdef0"]
kms_key_id         = "arn:aws:kms:us-east-1:123456789012:key/your-kms-key-id"

common_tags = {
  Environment = "production"
  Owner       = "cloud-security-team"
}

log_bucket_name = "XXXXXXXXXXXXXX"

aws_region = "us-east-1"

function_name = "secureLambdaFunction"
filename      = "path/to/lambda.zip"
handler       = "index.handler"
runtime       = "nodejs18.x"

memory_size = 256
timeout     = 15

environment_variables = {
  ENV = "production"
}

kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/your-kms-key-id"

subnet_ids         = ["subnet-0abcd1234efgh5678", "subnet-0abcd1234efgh5679"]
security_group_ids = ["sg-0123456789abcdef0"]

dead_letter_queue_arn = "arn:aws:sqs:us-east-1:123456789012:your-dlq-name"

tracing_mode = "Active"

common_tags = {
  Environment = "production"
  Owner       = "serverless-team"
}
