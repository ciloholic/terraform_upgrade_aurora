provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "ap-northeast-1"

  default_tags {
    tags = {
      Project     = var.service_name
      Environment = var.env
      Management  = "Terraform"
    }
  }
}

provider "random" {}
