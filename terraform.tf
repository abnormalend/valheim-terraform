terraform {

  cloud {
    organization = "abnormalend-terraform"
    workspaces {
      name = "Valheim"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.20.1"
    }
  }
  required_version = "~> 1.6.1"
}