resource "aws_vpc" "Bastion" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    Name = "Bastion"
  }
}

# Create an Internet Gateway for public subnets
resource "aws_internet_gateway" "bastion_igw" {
  vpc_id = aws_vpc.Bastion.id
}

resource "aws_subnet" "bastion-public" {
  vpc_id     = aws_vpc.Bastion.id
  cidr_block = "192.168.1.0/24"
  tags = {
    Name = "BastionPublic"
  }
}





