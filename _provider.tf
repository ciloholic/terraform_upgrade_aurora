provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Project     = var.service_name
      Environment = var.env
      Management  = "Terraform"
    }
  }
}

provider "random" {}
