variable "environment" {
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
  default     = null
}

variable "vpc_cidr" {
  type        = string
  description = "VPCのCIDRブロック"
}

variable "public_subnet_cidrs" {
  type        = map(string)
  description = "パブリックサブネットのCIDRブロック"
}

variable "private_subnet_cidrs" {
  type        = map(string)
  description = "パブリックサブネットのCIDRブロック"
}
