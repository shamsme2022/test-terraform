output "cloudfront_origin_Access_identity" {
  value = aws_cloudfront_origin_access_identity.aws_cf_test_shams_OAI.iam_arn
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.aws_cf_test_shams.domain_name
}
