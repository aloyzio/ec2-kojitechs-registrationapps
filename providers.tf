
terraform {
  required_version = ">=1.1.5"

  backend "s3" {
  bucket = "ec2-kojitechs-registrationapps-tf-2211"
  dynamodb_table = "terraform-lock"
  key = "path/env"
  region = "us-east-1"
  encrypt = "true"
  }
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}
provider "aws" {
  region  = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${lookup(var.env, terraform.workspace)}:role/Terraform_Admin_Role"
  }
}

variable "env" {
  type = map(any)
}