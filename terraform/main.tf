provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

# S3 bucket for static website
resource "aws_s3_bucket" "static-website-bucket" {
  bucket = "infinite-lambda-static-website-bucket"
  acl    = "public-read"
  website {
    index_document = "index.html"
  }
}

# RDS (postgreSQL) to connect to from EC2
resource "aws_db_instance" "postgres-RDS" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "12.5"
  instance_class         = "db.t2.micro"
  name                   = data.aws_ssm_parameter.DB_DBNAME.value
  username               = data.aws_ssm_parameter.DB_USER.value
  password               = data.aws_ssm_parameter.DB_PASSWORD.value
  vpc_security_group_ids = [aws_security_group.ec2-jenkins-sg.id]
  skip_final_snapshot    = true
}

# ECR for Docker image pushed by Jenkins from EC2
resource "aws_ecr_repository" "my-python-app-repo" {
  name = "my-python-app-repo"
}

# EC2 for Jenkins pipeline + SG
resource "aws_instance" "ec2-jenkins" {
  ami                         = "ami-0e0102e3ff768559b"
  instance_type               = "t2.micro"
  key_name                    = "il-homework-key"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2-jenkins-sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name

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