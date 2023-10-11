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
    Name = var.public_subnet_names[count.index]
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
    Name = var.private_subnet_names[count.index]
  }
}

resource "aws_eip" "prod_eip" {
  
}

resource "aws_nat_gateway" "prod_natgw" {
  subnet_id = aws_subnet.prodpublic[0].id
  allocation_id = aws_eip.prod_eip.id
}

resource "aws_route_table" "public_RT_prod" {
  vpc_id = aws_vpc.prodvpc.id

  route {
    gateway_id = aws_internet_gateway.prod_igw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "public_RT_prod"
  }

}

resource "aws_route_table_association" "publicRTA" {
  count = 2
  subnet_id = aws_subnet.prodpublic[count.index].id
  route_table_id = aws_route_table.public_RT_prod.id
}

resource "aws_route_table" "private_RT_prod1" {
  vpc_id = aws_vpc.prodvpc.id
  
  route {
    nat_gateway_id = aws_nat_gateway.prod_natgw.id
    cidr_block = "0.0.0.0/0"
  }
  
  tags = {
    Name = "Private_RT_prod1"
  }

}

resource "aws_route_table_association" "first_4_subnets_association" {
  count          = 4  # This specifies that we are associating the first 4 subnets
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_RT_prod1.id
}

resource "aws_route_table" "private_RT_prod2" {
  vpc_id = aws_vpc.prodvpc.id
  
  route {
    nat_gateway_id = aws_nat_gateway.prod_natgw.id
    cidr_block = "0.0.0.0/0"
  }
  
  tags = {
    Name = "Private_RT_prod2"
  }

}

resource "aws_route_table_association" "last_3_subnets_association" {
  count          = length(var.private_subnet_cidrs) - 4  # This specifies that we are associating the last 3 subnets
  subnet_id      = aws_subnet.private_subnets[count.index + 4].id
  route_table_id = aws_route_table.private_RT_prod2.id
}


