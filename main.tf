# Setting Up Remote State
terraform {
  # Terraform version at the time of writing this post
  required_version = ">= 0.12.24"

  backend "s3" {
    bucket = "testing-123-2"
    key    = "testing-123-2"
    region = "eu-west-1"
  }
}

# Terraform AWS Provider
# Docs: https://www.terraform.io/docs/providers/aws/index.html
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "eu-west-1"
}

variable "branch_name" {
  description = "The name of the branch that's being deployed"
}

resource "aws_s3_bucket" "primary" {
  bucket        = "acid-web-${var.branch_name}"
  force_destroy = true
  policy        = <<POLICY
{
  "Id": "bucket_policy_site",
  "Version":"2012-10-17",
  "Statement": [
    {
      "Sid": "PublicRead",
      "Action": ["s3:GetObject"],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::acid-web-${var.branch_name}/*",
      "Principal": "*"
    }
  ]
}
POLICY

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Name    = "Acid Web - PR"
    Branch    = var.branch_name
    Project = "Acid Web"
  }
}
#
