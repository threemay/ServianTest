

data "aws_route53_zone" "main" {
  name         = var.r53_hosted_zone_name
  private_zone = false
}

# SSL Certificate
resource "aws_acm_certificate" "ssl_certificate" {
  domain_name               = var.ssl_domain_name
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = data.aws_route53_zone.main.zone_id
    }
 }

 allow_overwrite = true
 name            = each.value.name
 records         = [each.value.record]
 ttl             = 60
 type            = each.value.type
 zone_id         = each.value.zone_id
}


output "certificate_arn" {
  value = aws_acm_certificate.ssl_certificate.arn
}

