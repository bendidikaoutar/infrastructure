terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "muestra-bucket"
    key            = "terraformstate/prod/state"
    region         = "eu-west-3"
    use_lockfile   = true
    encrypt        = true
  }
}

provider "aws" {
  region = var.muestra_region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}