provider "aws" {
  profile = "default"
  region = "eu-central-1"
}

# SSM Parameterstore already filled with parameters via management console
# Parameter names: DB_DBNAME, DB_ENDPOINT, DB_PASSWORD, DB_PORT, DB_REGION, DB_USER

# S3 bucket for static website

# RDS (postgreSQL) to connect to from EC2

# ECR for Docker image pushed by Jenkins from EC2

# EC2 for Jenkins pipeline
