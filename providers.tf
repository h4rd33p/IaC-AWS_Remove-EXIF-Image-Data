terraform {
  required_version = ">=1.5.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=5.0"
    }
    pgp = {
      source = "ekristen/pgp" // refer: https://registry.terraform.io/providers/ekristen/pgp/latest
    }
  }
}

provider "aws" {
  region = var.region
}
