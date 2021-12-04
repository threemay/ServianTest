
data "aws_route53_zone" "main" {
  name         = var.r53_hosted_zone_name
  private_zone = false
}



resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.r53_domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_hosted_zone_id
    evaluate_target_health = false
  }
}

