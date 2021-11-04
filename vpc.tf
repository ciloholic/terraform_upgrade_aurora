resource "aws_vpc" "example" {
  cidr_block           = local.network_config.vpc.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.service_config.prefix}-vpc"
  }
}
