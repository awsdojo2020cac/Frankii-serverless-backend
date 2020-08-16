terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  version = "~> 3.2"
  region  = "ap-northeast-1"
}