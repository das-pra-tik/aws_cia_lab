# AWS Route53 zone data source with the domain name and private zone set to false
data "aws_route53_zone" "r53_public_hosted_zone" {
  name         = var.domain_name
  private_zone = false
}

# AWS Route53 record resource for certificate validation.
resource "aws_route53_record" "r53_record_dvo" {
  for_each = {
    for dvo in aws_acm_certificate.domain_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = data.aws_route53_zone.r53_public_hosted_zone.zone_id
  ttl             = 60
}

# AWS Route53 record resource for the "cdn" and "alb" subdomains. The record uses an "A" type record and an alias to the AWS CloudFront distribution and ALB with the specified domain name and hosted zone ID.
# -----------------------------------------------------------------------------
# CREATE RECORD TYPE AS "A" IN ROUTE 53 POINTING AT THE CLOUDFRONT DISTRIBUTION
# -----------------------------------------------------------------------------
resource "aws_route53_record" "cdn" {
  zone_id = data.aws_route53_zone.r53_public_hosted_zone.id
  name    = "cdn.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.r53_cdn_domain_name
    zone_id                = var.r53_cdn_hosted_zone_id
    evaluate_target_health = false
  }
}

# --------------------------------------------------------------------
# CREATE RECORD TYPE AS "A" IN ROUTE 53 POINTING AT THE LOAD BALANCER
# --------------------------------------------------------------------
resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.r53_public_hosted_zone.id
  name    = "alb.${var.domain_name}"
  type    = "A"
  alias {
    name                   = var.r53_alb_domain_name
    zone_id                = var.r53_alb_hosted_zone_id
    evaluate_target_health = false
  }
}
/*
# AWS Route53 record resource for the apex domain (root domain) with an "A" type record. The record uses an alias to the AWS CloudFront distribution with the specified domain name and hosted zone ID.
resource "aws_route53_record" "apex" {
  zone_id = data.aws_route53_zone.r53_public_hosted_zone.id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.r53_cdn_domain_name
    zone_id                = var.r53_cdn_hosted_zone_id
    evaluate_target_health = false
  }
}
*/
