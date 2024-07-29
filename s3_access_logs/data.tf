data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  bucket_policy_default_permission = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  ]

  bucket_policy_permissions = local.bucket_policy_default_permission
}

## s3 bucket policy
data "aws_iam_policy_document" "s3_bucket_policy_doc" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    principals {
      type        = "AWS"
      identifiers = local.bucket_policy_permissions
    }

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
      "${aws_s3_bucket.s3_bucket.arn}"
    ]
  }
}
