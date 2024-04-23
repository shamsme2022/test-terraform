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

########## Creating a bucket from the S3 Module #######
module "s3" {
  source = "./s3"
}
