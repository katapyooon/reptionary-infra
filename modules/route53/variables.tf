variable "root_domain" {
  description = "root_domain"
  type        = string
}
variable "subdomain" {
  description = "subdomain"
  type        = string
}
variable "a_record_alias_name" {
  description = "A Record Alias Name"
  type        = string
}
variable "a_record_alias_zone_id" {
  description = "A Record Alias Zone Id"
  type        = string
}

variable "environment" {
  type        = string
}