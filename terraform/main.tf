provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

# SSM Parameterstore already filled with parameters via management console
# Parameter names: DB_DBNAME, DB_PASSWORD, DB_USER

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
        Resource  = "arn:aws:s3:::s3-static-website/*"
      },
    ]
  })
}

# RDS (postgreSQL) to connect to from EC2
resource "aws_db_instance" "postgres-RDS" {
  allocated_storage = 20
  engine            = "postgresql"
  engine_version    = "12.5"
  instance_class    = "db.t2.micro"
  name              = data.aws_ssm_parameter.DB_DBNAME.value
  username          = data.aws_ssm_parameter.DB_USER.value
  password          = data.aws_ssm_parameter.DB_PASSWORD.value
}

# todo EC2 security group id
# resource "aws_db_security_group" "postgres-RDS-SG" {
#   name = "postgres-RDS-SG"

#   ingress {
#     security_group_id = "value"
#   }
# }

# ECR for Docker image pushed by Jenkins from EC2

resource "aws_ecr_repository" "my-python-app" {
  name = "my-python-app"
}

# todo EC2 IAM role for principle 
resource "aws_ecr_repository_policy" "ecr-policy" {
  repository = aws_ecr_repository.my-python-app.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EC2PutImage"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
        ]
      },
    ]
  })
}

# EC2 for Jenkins pipeline
