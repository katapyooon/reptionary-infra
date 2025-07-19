data "aws_caller_identity" "current" {}
# ================
# ECS Cluster
# ================
resource "aws_ecs_cluster" "main" {
  name = "reptionary-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ================
# ECS AutoScaring
# ================
### Capacity Provider
resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    capacity_provider = "FARGATE"
  }
}

# ================
# ECS Task Definition
# ================
resource "aws_ecs_task_definition" "app" {
  family                   = "reptionary-${var.environment}-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name  = "app"
      image = var.ecr_image_url  # 例: "123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/reptionary:latest"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ================
# ECS Task IAM
# ================
resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ================
# ECS Service
# ================
resource "aws_ecs_service" "app" {
  name            = "reptionary-${var.environment}-app-service"
  cluster         = aws_ecs_cluster.main.id
  launch_type     = "FARGATE"
  desired_count   = 1
  task_definition = aws_ecs_task_definition.app.arn

  network_configuration {
    subnets         = var.public_subnet_ids
    security_groups = [var.security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "app"
    container_port   = 80
  }

  depends_on = [aws_ecs_task_definition.app]
}