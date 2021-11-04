resource "aws_subnet" "public_subnet" {
  for_each          = local.network_config.subnet.common
  vpc_id            = aws_vpc.example.id
  availability_zone = "${local.aws_config.region}${each.key}"
  cidr_block        = each.value

  tags = {
    Name = "${local.service_config.prefix}-public-subnet-${each.key}-common"
  }
}

resource "aws_subnet" "private_subnet_fargate" {
  for_each          = local.network_config.subnet.fargate
  vpc_id            = aws_vpc.example.id
  availability_zone = "${local.aws_config.region}${each.key}"
  cidr_block        = each.value

  tags = {
    Name = "${local.service_config.prefix}-private-subnet-${each.key}-fargate"
  }
}

resource "aws_subnet" "private_subnet_storage" {
  for_each          = local.network_config.subnet.storage
  vpc_id            = aws_vpc.example.id
  availability_zone = "${local.aws_config.region}${each.key}"
  cidr_block        = each.value

  tags = {
    Name = "${local.service_config.prefix}-private-subnet-${each.key}-storage"
  }
}
