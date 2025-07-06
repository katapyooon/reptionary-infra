variable "environment" {
  type        = string
}

variable "vpc_cidr" {
  type        = string
  description = "VPCのCIDRブロック"
}

variable "public_subnet_cidrs" {
  type        = map(string)
  description = "パブリックサブネットのCIDRブロック"
}