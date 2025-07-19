variable "environment" {}
variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "security_group_id" {}
variable "ecr_image_url" {}

variable "alb_target_group_arn" {
  description = "Target Group ARN for ALB"
  type        = string
}

variable "alb_listener_arn" {
  description = "Listener ARN for ALB"
  type        = string
}