# SSM Parameterstore already filled with parameters via management console 
# for DB_DBNAME, DB_USER, DB_PASSWORD
# Parameter names: DB_DBNAME, DB_ENDPOINT, DB_PASSWORD, DB_PORT, DB_REGION, DB_USER, REPO_URL

data "aws_ssm_parameter" "DB_DBNAME" {
  name = "DB_DBNAME"
}

data "aws_ssm_parameter" "DB_USER" {
  name = "DB_USER"
}

data "aws_ssm_parameter" "DB_PASSWORD" {
  name = "DB_PASSWORD"
}

resource "aws_ssm_parameter" "DB_PORT" {
  name      = "DB_PORT"
  type      = "String"
  overwrite = true
  value     = aws_db_instance.postgres-RDS.port
}

resource "aws_ssm_parameter" "DB_REGION" {
  name      = "DB_REGION"
  type      = "String"
  overwrite = true
  value     = "eu-cental-1"
}

resource "aws_ssm_parameter" "DB_ENDPOINT" {
  name      = "DB_ENDPOINT"
  type      = "String"
  overwrite = true
  value     = aws_db_instance.postgres-RDS.address
}

resource "aws_ssm_parameter" "REPO_URL" {
  name      = "REPO_URL"
  type      = "String"
  overwrite = true
  value     = aws_ecr_repository.my-python-app-repo.repository_url
}