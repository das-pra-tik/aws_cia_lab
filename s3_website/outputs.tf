output "s3_website_bucket_name" {
  value = aws_s3_bucket.s3-web-hosting-bucket.bucket
}

output "s3_bucket_regional_domain_name" {
  value = aws_s3_bucket.s3-web-hosting-bucket.bucket_regional_domain_name
}

output "s3_bucket_domain_name" {
  value = aws_s3_bucket.s3-web-hosting-bucket.bucket_domain_name
}
/*
output "aws_s3_bucket_policy" {
  value = aws_s3_bucket_policy.s3-web-hosting-bucket.policy
}
*/
