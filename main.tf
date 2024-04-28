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

#adding a hosted zone for the subdomain shams.ab
resource "aws_route53_zone" "zone_shams" {
  name    = "shams.abc.printdeal.com"
  comment = "Hosted Zone for shams.example.com"

  tags = {
    Name   = "shams.abc.printdeal.com"
    Origin = "terraform"
  }
}

#adding a record to the apex record for sub-domain
resource "aws_route53_record" "ns_record_shams" {
  type    = "NS"
  zone_id = data.aws_route53_zone.master_apex_hosted_zone.id
  name    = "shams"
  ttl     = "86400"
  records = aws_route53_zone.zone_shams.name_servers
}

