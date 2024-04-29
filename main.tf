terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# provider "aws" {
#   region = var.region
# }

provider "aws" {
  region = var.region
}

########## Creating a bucket from the s3 Module #######
module "s3" {
  source = "./s3"
  cf_arn = module.cf.cloudfront_distribution_arn
}

########## Creating a cloud front distruction with s3 #######
module "cf" {
  source              = "./cf"
  s3_origin_id        = module.s3.bucket_name
  s3_domain_name      = module.s3.s3_bucket_website_doamin
  access_control_name = module.s3.bucket_name
}



########## Fetching the existing hosted zone record for abc.printdeal.com
data "aws_route53_zone" "master_apex_hosted_zone" {
  name         = "abc.printdeal.com"
  private_zone = false
}

#adding an A record to shams.abc.printdeal.com to point it to cloudFront
resource "aws_route53_record" "ns_record_shams_cf" {
  type    = "A"
  zone_id = data.aws_route53_zone.master_apex_hosted_zone.id
  name    = "shams"

  alias {
    name                   = module.cf.cloudfront_url
    zone_id                = module.cf.hosted_zone
    evaluate_target_health = false
  }
}


