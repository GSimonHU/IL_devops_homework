provider "aws" {
  profile = "default"
  region = "eu-central-1"
}

# SSM Parameterstore already filled with parameters via management console
# Parameter names: DB_DBNAME, DB_ENDPOINT, DB_PASSWORD, DB_PORT, DB_REGION, DB_USER

# S3 bucket for static website
resource "aws_s3_bucket" "static-website-bucket" {
  bucket = "static-website-bucket"
  acl    = "public-read"
  website {
    index_document = "index.html"
  }
}

# todo EC2 IAM role for principle
resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.static-website-bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "EC2PutObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource = "arn:aws:s3:::s3-static-website/*"
      },
    ]
  })
}

# RDS (postgreSQL) to connect to from EC2

# ECR for Docker image pushed by Jenkins from EC2

# EC2 for Jenkins pipeline
