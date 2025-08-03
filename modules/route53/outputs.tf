output "acm_arn" {
  value = aws_acm_certificate.main.arn
}
output "acm_arn_logging" {
  value      = {}
  depends_on = [aws_acm_certificate_validation.main]
}