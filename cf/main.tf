
resource "aws_cloudfront_origin_access_identity" "aws_cf_test_shams_OAI" {
  comment = "Some comment"
}

resource "aws_cloudfront_distribution" "aws_cf_test_shams" {

  enabled = true

  origin {
    origin_id   = var.s3_origin_id
    domain_name = var.s3_domain_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.aws_cf_test_shams_OAI.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {

    target_origin_id = var.s3_origin_id
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "PriceClass_200"

}
