terraform {
  backend "s3" {
    bucket         = "demo-terraform-templates-24072025"
    key            = "app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
