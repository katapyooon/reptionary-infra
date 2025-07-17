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

# ================
# Target Group
# ================
resource "aws_lb_target_group" "alb" {
  name                 = "reptionary-${var.environment}-tg"
  vpc_id               = var.vpc_id
  port                 = 80
  target_type          = "ip"
  protocol             = "HTTP"
  deregistration_delay = 300
  health_check {
    path                = "/api/health_checks"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}