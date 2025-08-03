# ======================
# 既存の Hosted Zone を参照
# ======================
data "aws_route53_zone" "main" {
  name         = var.root_domain
  private_zone = false
}

# ======================
# ACM 証明書と検証
# ======================
resource "aws_acm_certificate" "main" {
  domain_name               = var.subdomain
  subject_alternative_names = ["*.${var.subdomain}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "certificate" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
    if dvo.domain_name != "*.staging.reptionary.jp"
  }

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate : record.fqdn]
}

# ======================
# Aレコード（ALBに向ける）
# ======================
resource "aws_route53_record" "a" {
  name    = var.subdomain
  type    = "A"
  zone_id = data.aws_route53_zone.main.zone_id

  alias {
    name                   = var.a_record_alias_name
    zone_id                = var.a_record_alias_zone_id
    evaluate_target_health = true
  }
}
