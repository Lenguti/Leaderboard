terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }

  backend "s3" {
    region               = "us-east-1"
    bucket               = "lenguti-tfstate"
    workspace_key_prefix = "lenguti-practice"
    key                  = "terraform.tfstate"
    encrypt              = true
    dynamodb_table       = "lenguti-terraform-state-lock"
    profile              = "lengutidev"
  }
}

provider "aws" {
  profile = "lengutidev"
  region  = "us-east-1"
}
