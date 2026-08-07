terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.56.0"
    }
  }

  backend "s3" {
    bucket       = "devops-practice-90"
    key          = "roboshop-frontend.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true

  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# # Create a VPC
# resource "aws_vpc" "example" {
#   cidr_block = "10.0.0.0/16"
# }