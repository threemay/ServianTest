
## AWS infrastructure

![architecture](images/Mydrawio.png)

## Pre requisites

* Terraform
* AWS Cli (IAM user with permissions in IAM, ECS, VPC, ALB, RDS ...)
* An hosted zone in route53

## Process instructions

Change the variables in the tf-file-fargate [terraform.tfvars](./tf-file-fargate/terraform.tfvars)

And get into the tf-file-fargate run
```
Terraform init
Terraform apply -auto-approve
```

For destroy all resources run
```
Terraform destroy -auto-approve
```

if want use terraform state file and lock file, need to build a bucket in s3 and dynomodb.

## Security

Used:
* Private and public subnets
* Security groups
* NAT
* ACLs
* ACM

  and ...

## Auto scaling

Auto scaling for fargate in two metrics: memory and CPU

## Highly available frontend

Multi-AZ for Fargate

## Highly available Database

Could build Multi-AZ for Database (cost a lot no use in this case)


