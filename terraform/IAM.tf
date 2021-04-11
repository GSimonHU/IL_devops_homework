# IAM resources for EC2

resource "aws_iam_role" "EC2_role_for_Jenkins" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy_for_EC2" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:PutImage"
      ],
      "Effect": "Allow",
      "Resource": "${aws_ecr_repository.my-python-app-repo.arn}"
    },
    {
      "Action": [
        "ssm:GetParameters"
      ],
      "Effect": "Allow",
      "Resource": [
          "${aws_ssm_parameter.DB_PORT.arn}",
          "${aws_ssm_parameter.DB_REGION.arn}",
          "${aws_ssm_parameter.DB_ENDPOINT.arn}",
          "${data.aws_ssm_parameter.DB_DBNAME.arn}",
          "${data.aws_ssm_parameter.DB_USER.arn}",
          "${data.aws_ssm_parameter.DB_PASSWORD.arn}"
      ]
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.static-website-bucket.arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  role = aws_iam_role.EC2_role_for_Jenkins.name
}

resource "aws_iam_role_policy_attachment" "role-attach" {
  role       = aws_iam_role.EC2_role_for_Jenkins.name
  policy_arn = aws_iam_policy.policy_for_EC2.arn
}