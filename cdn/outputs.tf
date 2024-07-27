output "cdn_domain_name" {
  value = aws_cloudfront_distribution.cdn_static_website.domain_name
}

output "cdn_hosted_zone_id" {
  value = aws_cloudfront_distribution.cdn_static_website.hosted_zone_id
}

output "cdn_arn" {
  value = aws_cloudfront_distribution.cdn_static_website.arn
}

