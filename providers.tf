terraform {
  required_version = ">=1.1.5"


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region

 profile = "default"

   default_tags {
    tags = local.mandatory_tag
  }
}