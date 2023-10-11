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
    Name = "Public_subnet_bastion"
  }
}

# Creating public route table for bastion VPC with IGW
resource "aws_route_table" "public_RT_bastion" {
  vpc_id = aws_vpc.Bastion.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bastion_igw.id
  }

  tags = {
    Name = "Public_RT_Bastion"
  }
}

resource "aws_route_table_association" "bastion_RT_association" {
  subnet_id = aws_subnet.bastion-public.id
  route_table_id = aws_route_table.public_RT_bastion.id
}

resource "aws_security_group" "bastionSG" {
  vpc_id = aws_vpc.Bastion.id
  name = "bastionSG"
  description = "bastion security group"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}







