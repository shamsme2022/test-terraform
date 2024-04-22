resource "aws_s3_bucket" "test_bucket_shams" {
  bucket_prefix = var.bucket_prefix
  versioning {
    enabled = var.versioning
  }
  logging {
    target_bucket = var.target_bucket
    target_prefix = var.target_prefix
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_master_key_id
        sse_algorithm     = var.sse_algorithm
      }
    }
  }
  tags = var.tags
}

resource "aws_s3_bucket_ownership_controls" "shams_test_s3_bucket_ownerships_controls" {
  bucket = aws_s3_bucket.test_bucket_shams.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "shams_test_s3_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.shams_test_s3_bucket_ownerships_controls]

  bucket = aws_s3_bucket.test_bucket_shams.id
  acl    = "private"
}
