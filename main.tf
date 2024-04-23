terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

########## Creating a bucket from the s3 Module #######
module "s3" {
  source = "./s3"
}

########## Creating a cloud front distruction with s3 #######
module "cf" {
  source         = "./cf"
  s3_origin_id   = module.s3.bucket_name
  s3_domain_name = module.s3.bucket_doamin
}
