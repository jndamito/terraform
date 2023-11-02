resource "aws_vpc" "prodvpc" {
  cidr_block       = "10.32.0.0/16"
  instance_tenancy = "default"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "eks_vpc"
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
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/demo" = "owned"
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
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/demo" = "owned"
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

  depends_on = [ aws_subnet.prodpublic ]

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

  depends_on = [ aws_subnet.private_subnets ]
  
  route {
    nat_gateway_id = aws_nat_gateway.prod_natgw.id
    cidr_block = "0.0.0.0/0"
  }
  
  tags = {
    Name = "Private_RT_prod1"
  }

}

resource "aws_route_table_association" "private_RTA" {
  count          = 4  # This specifies that we are associating the first 4 subnets
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_RT_prod1.id
}


/*
# Transit gateway

resource "aws_ec2_transit_gateway" "tgw" {
  description = "TGW for prod and Bastion"
}

# Transit gateway attachement for Bastion

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_bastion" {
  subnet_ids         = [aws_subnet.bastion-public.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.Bastion.id
}

# Transit gateway attachment for Prod
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_prod" {
  for_each = {
    "subnet1" = aws_subnet.private_subnets[4].id,
    "subnet2" = aws_subnet.private_subnets[5].id
  }

  subnet_ids         = [each.value]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id            = aws_vpc.prodvpc.id

}

# Transit gateway route table

resource "aws_ec2_transit_gateway_route_table" "tgw_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

# Transit gateway route table association and propagation for bastion_vpc
resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_association" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw_bastion.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_propagation" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw_bastion.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

# Transit gateway route table association and propagation for prod_vpc
resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_association2" {
  for_each = {
    "subnet4" = aws_subnet.private_subnets[4].id,
    "subnet5" = aws_subnet.private_subnets[5].id
  }

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw_prod[each.value].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_propagation2" {
  for_each = {
    "subnet4" = aws_subnet.private_subnets[4].id,
    "subnet5" = aws_subnet.private_subnets[5].id
  }
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw_prod[each.value].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}
*/