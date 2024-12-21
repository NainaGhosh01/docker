provider "aws" {
  region = "us-east-1"
}

# S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-s3-bucket-${random_string.suffix.result}"
}

# Random Suffix for Bucket
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# RDS Instance
resource "aws_rds_instance" "my_rds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "mydatabase"
  username             = "admin"
  password             = "password123"
  publicly_accessible  = true
}

# Glue Catalog Database
resource "aws_glue_catalog_database" "my_glue_database" {
  name = "my_glue_database"
}

# ECR Repository
resource "aws_ecr_repository" "my_repo" {
  name = "my-docker-repo"
}

# Lambda Function
resource "aws_lambda_function" "my_lambda" {
  function_name = "s3-to-rds-glue"
  role          = "arn:aws:iam::<your-account-id>:role/<your-existing-role-name>" # Replace with your IAM Role ARN
  image_uri     = "${aws_ecr_repository.my_repo.repository_url}:latest"
}

# Terraform Outputs
output "ecr_repository_url" {
  value = aws_ecr_repository.my_repo.repository_url
}

output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}

output "rds_endpoint" {
  value = aws_rds_instance.my_rds.endpoint
}
