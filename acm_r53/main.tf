# ACM certificate resource with the domain name and DNS validation method
resource "aws_acm_certificate" "domain_cert" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = [var.alt_domain_name]

  lifecycle {
    create_before_destroy = true
  }
}

# ACM certificate validation resource using the certificate ARN and a list of validation record FQDNs.
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.domain_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.r53_record_dvo : record.fqdn]
}
