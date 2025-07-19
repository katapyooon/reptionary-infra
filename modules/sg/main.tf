resource "aws_security_group" "this" {
  name        = "reptionary-${var.environment}-sg"
  description = "Security group for reptionary ${var.environment} environment"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name        = "reptionary-${var.environment}-sg"
    Environment = var.environment
    Project     = "reptionary"
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group" "rds" {
  name        = "reptionary-${var.environment}-rds-sg"
  description = "Security group for RDS in ${var.environment} environment"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow PostgreSQL from ECS"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups  = [aws_security_group.this.id]  # ECSからの通信のみ許可
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "reptionary-${var.environment}-rds-sg"
    Environment = var.environment
    Project     = "reptionary"
    ManagedBy   = "terraform"
  }
}