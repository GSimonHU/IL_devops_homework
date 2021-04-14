# Infinite Lambda DevOps Homework

- Infrastructure was provisioned using Terraform with the files stored in the `terraform` folder
- RDS instance was provisioned using `DB_DBNAME`, `DB_USER`, and `DB_PASSWORD` parameters already defined in the `SSM Parameter Store` before running Terraform
- Other parameters (`DB_ENDPOINT`, `DB_PORT`, `DB_REGION`) created during infrastructure provisioning were put in the `SSM Parameter Store`
- Jenkins is running on an EC2 previously provisioned by Terraform. Everything was configured in the EC2 using the script file in the `EC2_setup` folder
- Jenkins itself uses GitHub credentials and the Blue Ocean plugin
- Application (in `app` folder) built and run by Jenkins uses the parameters from the `SSM Parameter Store` to connect to RDS instance
- Static website (in `static_website` folder) is uploaded to an S3 bucket and available as a public static website