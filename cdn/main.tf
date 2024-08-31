# CloudFront distribution with S3 origin, HTTPS redirect, IPv6 enabled, no cache, and ACM SSL certificate.
resource "aws_cloudfront_distribution" "cdn_static_website" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "login.html"

  origin {
    domain_name              = var.domain_name
    origin_id                = "cia-lab-s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.cdn-oac.id
  }

  aliases = [var.alt_domain_name]

  default_cache_behavior {
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "cia-lab-s3-origin"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      locations        = ["IN", "US", "CA"]
      restriction_type = "whitelist"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

# CloudFront origin access control for S3 origin type with always signing using sigv4 protocol
resource "aws_cloudfront_origin_access_control" "cdn-oac" {
  name                              = "Cloudfront OAC"
  description                       = "Cloudfront OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Default cache policy for Cloudfront
resource "aws_cloudfront_cache_policy" "cdn_default_cache_policy" {
  name        = "cdn-default-cache-policy"
  comment     = "cdn-default-cache-policy"
  default_ttl = 50
  max_ttl     = 100
  min_ttl     = 1

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "all"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "all"
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}
