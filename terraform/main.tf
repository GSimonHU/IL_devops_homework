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
resource "aws_db_security_group" "postgres-RDS-SG" {
  name = "postgres-RDS-SG"

  ingress {
    security_group_id = aws_security_group.ec2-jenkins-sg.id
  }
}

# ECR for Docker image pushed by Jenkins from EC2

resource "aws_ecr_repository" "my-python-app-repo" {
  name = "my-python-app-repo"
}

# todo EC2 IAM role for principle 
resource "aws_ecr_repository_policy" "ecr-policy" {
  repository = aws_ecr_repository.my-python-app-repo.name
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
resource "aws_instance" "ec2-jenkins" {
  ami                         = "ami-0e0102e3ff768559b"
  instance_type               = "t2.micro"
  key_name                    = "il-homework-key"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2-jenkins-sg.id]

  tags = {
    Name = "ec2-jenkins"
  }

  # user_data = <<EOF
  # #!/bin/sh
  # sudo apt-get update
  # sudo apt-get install -y mysql-server
  # EOF
}

resource "aws_security_group" "ec2-jenkins-sg" {
  name = "ec2-jenkins-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    self      = true
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

