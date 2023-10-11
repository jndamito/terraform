variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["172.32.1.0/24", "172.32.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["172.32.4.0/24", "172.32.5.0/24", "172.32.6.0/24", "172.32.7.0/24", "172.32.8.0/24", "172.32.9.0/24", "172.32.10.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnet_names" {
  type = list(string)
  default = [ "Private_subnet1_nginx", "Private_subnet2_nginx", "Private_subnet3_app", "Private_subnet4_app", "Private_subnet5_nlb", "Private_subnet6_nlb", "Private_subnet6_maven" ]
}

variable "public_subnet_names" {
  type = list(string)
  default = [ "Public_subnet_NLB_NAT_1", "Public_subnet_NLB_NAT_2" ]
}

