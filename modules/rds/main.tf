resource "aws_db_subnet_group" "rds" {
  name       = "reptionary-${var.environment}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "reptionary-${var.environment}-rds-subnet-group"
  }
}

resource "aws_db_instance" "rds" {
  identifier              = "reptionary-${var.environment}-db"
  engine                  = "postgres"
  engine_version          = "17.4"
  instance_class          = "db.t4g.micro"
  allocated_storage       = 20
  username                = var.db_username
  password                = var.db_password
  db_name                 = "reptionary"
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = [var.security_group_id]
  db_subnet_group_name    = aws_db_subnet_group.rds.name

  tags = {
    Environment = var.environment
    Project     = "reptionary"
    ManagedBy   = "terraform"
  }
}