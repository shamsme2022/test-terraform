output "bucket_doamin" {
  value = aws_s3_bucket.test_bucket_shams.bucket_regional_domain_name
}


output "bucket_name" {
  value = aws_s3_bucket.test_bucket_shams.id
}

output "s3_bucket_website_doamin" {
  value = aws_s3_bucket.test_bucket_shams.bucket_domain_name
}
