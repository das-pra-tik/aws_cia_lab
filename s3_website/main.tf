# Creating S3 bucket and apply force destroy So, when going to destroy it won't throw error 'Bucket is not empty'
resource "aws_s3_bucket" "s3-web-hosting-bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_cors_configuration" "s3_cors" {
  bucket = aws_s3_bucket.s3-web-hosting-bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://www.${var.s3_bucket_name}"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}
/*
# Using null resource to push all the files in one time
resource "null_resource" "upload-to-S3" {
  provisioner "local-exec" {
    command = "aws s3 sync ${path.module}/2136_kool_form_pack s3://${aws_s3_bucket.s3-web-hosting-bucket.id} --region us-east-1"
  }
}
*/
resource "aws_s3_object" "upload-to-S3" {
  bucket   = var.s3_bucket_name
  for_each = fileset("2136_kool_form_pack/", "*/*.*")
  key      = each.value
  source   = "2136_kool_form_pack/${each.value}"
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "s3_public_access_block" {
  bucket = aws_s3_bucket.s3-web-hosting-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Static website configuration
resource "aws_s3_bucket_website_configuration" "web_app_bucket_config" {
  bucket = aws_s3_bucket.s3-web-hosting-bucket.id
  index_document {
    suffix = "login.html"
  }
  error_document {
    key = "404.html"
  }
}

# Creating the S3 policy and applying it for the S3 bucket
resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.s3-web-hosting-bucket.id
  policy = data.aws_iam_policy_document.website_bucket.json
}
