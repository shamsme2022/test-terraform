
# data "aws_acm_certificate" "issued_abc_printdeal_com" {
#   domain   = "*.abc.printdeal.com"
#   statuses = ["ISSUED"]
# }

resource "aws_acm_certificate" "cert_abc_printdeal_com_us_east_1" {
  domain_name       = "*.abc.printdeal.com"
  validation_method = "DNS"

  tags = {
    Environment = "us-east-1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudfront_distribution" "aws_cf_test_shams" {

  enabled = true

  aliases = ["shams.abc.printdeal.com"]

  origin {
    origin_id                = var.s3_origin_id
    domain_name              = var.s3_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.aws_cf_test_shams_s3_oac.id
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
    # cloudfront_default_certificate = true
    acm_certificate_arn = aws_acm_certificate.cert_abc_printdeal_com_us_east_1.arn
    ssl_support_method  = "sni-only"
  }

  price_class = "PriceClass_200"

}

resource "aws_cloudfront_origin_access_control" "aws_cf_test_shams_s3_oac" {
  name                              = var.access_control_name
  description                       = "Cloud Front S3 OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
