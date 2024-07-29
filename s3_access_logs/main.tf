resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_access_logs_bucket

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  depends_on = [aws_s3_bucket.s3_bucket]
  bucket     = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lc" {
  depends_on = [aws_s3_bucket_versioning.s3_bucket_versioning]

  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    id     = "default"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = var.default_retention_noncurrent_days
    }
  }

  rule {
    id     = "archive_retention"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = var.archive_retention_noncurrent_days
    }
    filter {
      prefix = "archives"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_pab" {
  depends_on = [aws_s3_bucket_lifecycle_configuration.s3_bucket_lc]

  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_sse_config" {
  depends_on = [aws_s3_bucket_public_access_block.s3_bucket_pab]

  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_oc" {
  depends_on = [aws_s3_bucket_server_side_encryption_configuration.s3_bucket_sse_config]

  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_oc]
  bucket     = aws_s3_bucket.s3_bucket.id
  policy     = data.aws_iam_policy_document.s3_bucket_policy_doc.json
}
