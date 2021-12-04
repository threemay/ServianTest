

# terraform {
#   backend "s3" {
#     bucket  = "terraform-remote-state-storage-s3-holly"
#     encrypt = true
#     key     = "terraform.tfstate"
#     region  = "ap-southeast-2"
#     # dynamodb_table = "terraform-state-lock-dynamo" 
#   }
# }

# resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
#   name           = "terraform-state-lock-dynamo"
#   hash_key       = "LockID"
#   billing_mode   = "PAY_PER_REQUEST"
#   read_capacity  = 20
#   write_capacity = 20
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
#   tags = {
#     Name = "DynamoDB Terraform State Lock Table"
#   }
# }

module "vpc" {
  source             = "./vpc"
  name               = var.name
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

module "acm" {
  source             = "./acm"
  ssl_domain_name = var.domain_name
  r53_region = var.aws-region
  r53_hosted_zone_name = var.hosted_zone_name
}

module "alb" {
  source              = "./alb"
  name                = var.name
  vpc_id              = module.vpc.id
  subnets             = module.vpc.public_subnets
  environment         = var.environment
  alb_security_groups = [module.security_groups.alb]
  alb_tls_cert_arn    = module.acm.certificate_arn
  health_check_path   = var.health_check_path
}

module "route53" {
  source             = "./route53"
  r53_domain_name        = var.domain_name
  r53_hosted_zone_name = var.hosted_zone_name
  alb_dns_name = module.alb.alb_dns
  alb_hosted_zone_id = module.alb.alb_zone_id
}



module "security_groups" {
  source         = "./security-groups"
  name           = var.name
  vpc_id         = module.vpc.id
  environment    = var.environment
  container_port = var.container_port
}


module "db" {
  source              = "./db"
  subnets             = module.vpc.private_subnets
  db_security_groups = [module.security_groups.db]
}

module "ecs" {
  source                      = "./ecs"
  name                        = var.name
  environment                 = var.environment
  region                      = var.aws-region
  subnets                     = module.vpc.private_subnets
  # subnets                     = module.vpc.public_subnets
  aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  ecs_service_security_groups = [module.security_groups.ecs_tasks]
  container_port              = var.container_port
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  service_desired_count       = var.service_desired_count
  container_image             = var.container_image
  db_address = module.db.db_adr
}

