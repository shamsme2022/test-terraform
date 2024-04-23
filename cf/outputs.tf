output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.aws_cf_test_shams.arn
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.aws_cf_test_shams.domain_name
}
