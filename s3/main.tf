resource "aws_s3_bucket" "test_bucket_shams" {
  bucket_prefix = var.bucket_prefix
  versioning {
    enabled = var.versioning
  }
  logging {
    target_bucket = var.target_bucket
    target_prefix = var.target_prefix
  }
  tags = var.tags
}

################################ Key and key attachment for bucket encryption start ##########################
resource "aws_kms_key" "test_bucket_shams_encryption_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "test_bucket_shams_encryption_config" {
  bucket = aws_s3_bucket.test_bucket_shams.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.test_bucket_shams_encryption_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
################################ Key and key attachment for bucket encryption end ##########################


################################ Ownership controls and ACL Start ##########################
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
################################ Ownership controls and ACL End ##########################
