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
}