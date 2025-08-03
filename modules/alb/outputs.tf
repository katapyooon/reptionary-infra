output "alb_id" {
  value = aws_alb.alb.id
  description = "ALB ID"
}

output "target_group_arn" {
  value = aws_lb_target_group.alb.arn
}

output "listener_arn" {
  value = aws_lb_listener.http.arn
}

output "dns_name" {
  value = aws_alb.alb.dns_name
}

output "zone_id" {
  value = aws_alb.alb.zone_id
}