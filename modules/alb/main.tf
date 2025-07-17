resource "aws_alb" "alb" {
  name               = "reptionary-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name        = "reptionary-${var.environment}-alb"
    Environment = var.environment
    Project     = "reptionary"
    ManagedBy   = "terraform"
  }
}
