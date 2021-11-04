resource "aws_ssm_parameter" "aurora_master_password" {
  name  = "/${local.service_config.name}/${local.service_config.env}/aurora-master-password"
  type  = "SecureString"
  value = aws_rds_cluster.example.master_password
}

resource "aws_ssm_parameter" "database_password" {
  name  = "/${local.service_config.name}/${local.service_config.env}/database-password"
  type  = "SecureString"
  value = random_password.aurora_example_password.result
}

resource "aws_ssm_parameter" "database_host" {
  name   = "/${local.service_config.name}/${local.service_config.env}/database-host"
  type   = "SecureString"
  key_id = aws_kms_key.example.key_id
  value  = aws_rds_cluster.example.endpoint
}
