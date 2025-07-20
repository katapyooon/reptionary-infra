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

resource "aws_subnet" "private" {
  for_each = var.private_subnet_cidrs

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = "ap-northeast-${each.key}"

  tags = {
    Name        = "reptionary-${var.environment}-private-${each.key}"
    Environment = var.environment
  }
}

# ================
# Internet Gateway
# ================
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.this.id
}

# ================
# Route Table
# ================
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = {
    Public = true
  }
}

# ================
# Route
# ================
resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
}

# ================
# Route Association
# ================
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}