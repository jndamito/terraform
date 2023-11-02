variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.32.1.0/24", "10.32.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.32.4.0/24", "10.32.5.0/24", "10.32.6.0/24", "10.32.7.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnet_names" {
  type = list(string)
  default = [ "Private_subnet1", "Private_subnet2", "Private_subnet3", "Private_subnet4"]
}

variable "public_subnet_names" {
  type = list(string)
  default = [ "Public_subnet_1", "Public_subnet_2" ]
}

