resource "random_password" "aurora_master_password" {
  length  = 16
  special = false
}

resource "random_password" "aurora_example_password" {
  length  = 16
  special = false
}
