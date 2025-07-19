terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"
}

module "vpc" {
  source = "../../modules/vpc"

  environment = "stg"
  vpc_cidr    = "10.0.0.0/16"
  public_subnet_cidrs = {
    "1a" = "10.0.1.0/24"
    "1c" = "10.0.2.0/24"
  }
  private_subnet_cidrs = {
    "1a" = "10.0.11.0/24"
    "1c" = "10.0.12.0/24"
  }
}

module "ecr" {
    source = "../../modules/ecr"

    environment = "stg"
}

module "sg" {
  source = "../../modules/sg"

  environment = "stg"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "Allow HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "alb" {
  source = "../../modules/alb"

  environment = "stg"
  vpc_id      = module.vpc.vpc_id
  security_group_id  = module.sg.security_group_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  ingress_rules = [
    {
      description = "Allow HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  
}

module "ecs" {
  source = "../../modules/ecs"

  environment = "stg"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  security_group_id   = module.sg.security_group_id
  ecr_image_url       = module.ecr.image_url

  alb_target_group_arn = module.alb.target_group_arn
  alb_listener_arn     = module.alb.listener_arn
}

module "rds" {
  source = "../../modules/rds"

  environment = "stg"
  db_username         = data.aws_ssm_parameter.db_username.value
  db_password         = data.aws_ssm_parameter.db_password.value
  db_name             = "reptionary"
  private_subnet_ids  = module.vpc.private_subnet_ids
  security_group_id   = module.sg.rds_security_group_id
}

data "aws_ssm_parameter" "db_username" {
  name = "/reptionary/stg/db_username"
}

data "aws_ssm_parameter" "db_password" {
  name            = "/reptionary/stg/db_password"
  with_decryption = true
}