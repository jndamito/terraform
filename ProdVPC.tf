resource "aws_vpc" "prodvpc" {
  cidr_block       = "172.32.0.0/16"
  instance_tenancy = "default"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "prodvpc"
  }
}

# Create an Internet Gateway for public subnets
resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.prodvpc.id
}

#Create public-subnets
resource "aws_subnet" "prodpublic" {
  vpc_id                  = aws_vpc.prodvpc.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Prod-public ${count.index + 1}"
  }
}

# Create private subnets
resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.prodvpc.id
  count                   = length(var.private_subnet_cidrs)
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "Prod-private ${count.index + 1}"
  }
}