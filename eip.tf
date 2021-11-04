resource "aws_eip" "natgw" {
  depends_on = [aws_internet_gateway.igw]
  for_each   = toset(local.network_config.availability_zones)
  vpc        = true

  tags = {
    Name = "${local.service_config.prefix}-eip-natgw-${each.value}"
  }
}
