terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "muestra_bucket"
    key            = "terraformstate/prod/state"
    region         = "eu-west-3"
    dynamodb_table = "muestra_dynamodb"
    encrypt        = true
  }
}

provider "aws" {
  region = var.muestra_region
}