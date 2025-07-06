resource "aws_ecr_repository" "reptionaryApp" {
  name = "reptionary-${var.environment}-app"

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Environment = var.environment
    Project     = "reptionary"
    ManagedBy   = "terraform"
  }
}