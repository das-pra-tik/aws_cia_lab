# Terraform Block
terraform {
  required_version = "~>1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.30.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">=3.1.0"
    }
  }

  backend "s3" {
    bucket  = "374278-terraform-tfstate"
    key     = "dev/dynamicblock-complexmap.tfstate"
    encrypt = "true"
    region  = "us-east-1"
    profile = "tf-admin"
  }
}
