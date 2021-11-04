resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "${local.service_config.prefix}-public-route-table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_route_table_association_common" {
  for_each       = toset(local.network_config.availability_zones)
  subnet_id      = aws_subnet.public_subnet[each.value].id
  route_table_id = aws_route_table.public_route_table.id
}
