terraform {
  required_version = "1.2.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.17.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
    }
  }
}
