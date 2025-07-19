variable "environment" {}
variable "db_username" {}
variable "db_password" {}
variable "db_name" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "security_group_id" {}