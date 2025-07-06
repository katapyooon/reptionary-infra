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