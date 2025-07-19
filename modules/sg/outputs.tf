output "security_group_id" {
  value       = aws_security_group.this.id
  description = "The ID of the created security group"
}

output "rds_security_group_id" {
  value       = aws_security_group.rds.id
  description = "The ID of the created RDS security group"
}