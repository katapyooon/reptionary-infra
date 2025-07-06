provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Environment = terraform.workspace
      Project     = "reptionary"
      ManagedBy   = "terraform"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"
}