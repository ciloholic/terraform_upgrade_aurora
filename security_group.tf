resource "aws_security_group" "aurora" {
  vpc_id = aws_vpc.example.id
  name   = "${local.service_config.prefix}-aurora"

  tags = {
    Name = "${local.service_config.prefix}-aurora"
  }
}

resource "aws_security_group_rule" "aurora_ingress_1" {
  for_each          = toset(local.network_config.availability_zones)
  security_group_id = aws_security_group.aurora.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 5432
  to_port           = 5432
  cidr_blocks = [
    aws_subnet.public_subnet[each.value].cidr_block,
    aws_subnet.private_subnet_fargate[each.value].cidr_block
  ]
}

resource "aws_security_group_rule" "aurora_egress_1" {
  security_group_id = aws_security_group.aurora.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
