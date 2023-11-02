provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "class32devops"
    key    = "eks_cluster/terraform.tfstate"
    region = "us-east-1"
}
}