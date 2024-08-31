# Terraform Block
terraform {
  required_version = "~>1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }

  backend "s3" {
    bucket  = "374278-terraform-tfstate"
    key     = "prod/aws-cia-lab.tfstate"
    encrypt = "true"
    region  = "us-east-1"
    # profile = "tf_user"
  }
}
