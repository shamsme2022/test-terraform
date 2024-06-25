
### SSL certificate for the subdomain
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

##### s3 bucket for standard CloudFront logging
resource "aws_s3_bucket" "cf_standard_logging_bucket" {
  bucket_prefix = "cflogs"
  tags = {
    Name = "cf-logs"
  }
}

resource "aws_s3_bucket_ownership_controls" "cf_standard_logging_bucket_owner_ship" {
  bucket = aws_s3_bucket.cf_standard_logging_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

### CouldFront distribution
resource "aws_cloudfront_distribution" "aws_cf_test_shams" {

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["shams.abc.printdeal.com"]

  origin_group {
    origin_id = "distribution"

    member {
      origin_id = var.s3_primary_origin_id
    }
    member {
      origin_id = var.s3_failover_origin_id
    }
    failover_criteria {
      status_codes = [403, 404, 500, 502, 503, 504]
    }
  }

  origin {
    origin_id                = var.s3_primary_origin_id
    domain_name              = var.s3_primary_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.aws_cf_test_shams_s3_oac.id
  }

  origin {
    origin_id                = var.s3_failover_origin_id
    domain_name              = var.s3_failover_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.aws_cf_test_shams_s3_oac.id
  }


  default_cache_behavior {

    target_origin_id = "distribution"
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

    function_association {
      event_type   = "viewer-response"
      function_arn = aws_cloudfront_function.cf_function.arn
    }
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

  logging_config {
    include_cookies = false
    bucket          = "${aws_s3_bucket.cf_standard_logging_bucket.id}.s3.amazonaws.com"
    prefix          = "logs"
  }

  price_class = "PriceClass_All"

}

### OAC For the CloudFront distribution to access the designated S3 bucket
resource "aws_cloudfront_origin_access_control" "aws_cf_test_shams_s3_oac" {
  name                              = var.access_control_name
  description                       = "Cloud Front S3 OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


### Lambda edge for setting security headers
resource "aws_lambda_function" "lambda_setting_security_headers" {
  description      = "Lambda edge for setting security headers"
  function_name    = "lambda-set-security-headers"
  runtime          = "nodejs20.x"
  handler          = "lambda.handler"
  memory_size      = 128
  timeout          = 10
  filename         = "lambda-edge.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  role             = aws_iam_role.role_for_lambda.arn
  publish          = true
}

### IAM role for lamda edge to assume
resource "aws_iam_role" "role_for_lambda" {
  name               = "iam-role-for-lambda-security-headers"
  description        = "IAM role for lambda security headers"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
}

### CloudFront Function
resource "aws_cloudfront_function" "cf_function" {
  name    = "security-header-function"
  comment = "Setup security response headers"
  runtime = "cloudfront-js-1.0"
  code    = file("${path.module}/function.js")
}
