# SSM Parameterstore already filled with parameters via management console
# Parameter names: DB_DBNAME, DB_PASSWORD, DB_USER

data "aws_ssm_parameter" "DB_DBNAME" {
  name = "DB_DBNAME"
}

data "aws_ssm_parameter" "DB_PASSWORD" {
  name = "DB_PASSWORD"
}

data "aws_ssm_parameter" "DB_USER" {
  name = "DB_USER"
}