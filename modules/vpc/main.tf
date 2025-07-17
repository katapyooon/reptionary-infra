resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "reptionary-${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnet_cidrs

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = "ap-northeast-${each.key}"
  map_public_ip_on_launch = true

  tags = {
    Name        = "reptionary-${var.environment}-public-${each.key}"
    Environment = var.environment
  }
}