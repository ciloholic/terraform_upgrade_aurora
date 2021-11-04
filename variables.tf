data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

variable "aws_access_key" {
  type      = string
  sensitive = true
}
variable "aws_secret_key" {
  type      = string
  sensitive = true
}
variable "service_name" {
  type = string
}
variable "env" {
  type = string
}
variable "aurora_master_username" {
  type = string
}
variable "aurora_engine_version" {
  type = string
}
variable "aurora_cluster_instance_count" {
  type = number
}
variable "aurora_instance_class" {
  type = string
}
variable "aurora_backup_retention_period" {
  type = number
}

locals {
  service_config = {
    name   = var.service_name
    env    = var.env
    prefix = "${var.service_name}-${var.env}"
  }
  aws_config = {
    aws_account_id = data.aws_caller_identity.current.account_id
    region         = data.aws_region.current.name
  }
  network_config = {
    vpc = {
      cidr_block = "10.0.0.0/16"
    }
    availability_zones = ["a", "c"]
    subnet = {
      "common" = {
        "a" = "10.0.1.0/24"
        "c" = "10.0.2.0/24"
      }
      "fargate" = {
        "a" = "10.0.11.0/24"
        "c" = "10.0.12.0/24"
      }
      "storage" = {
        "a" = "10.0.21.0/24"
        "c" = "10.0.22.0/24"
      }
    }
  }
  aurora_config = {
    master_username         = var.aurora_master_username
    family                  = "aurora-postgresql11"
    engine                  = "aurora-postgresql"
    engine_version          = var.aurora_engine_version
    cluster_instance_count  = var.aurora_cluster_instance_count
    instance_class          = var.aurora_instance_class
    backup_retention_period = var.aurora_backup_retention_period
    ca_cert_identifier      = "rds-ca-2019"
  }
}
