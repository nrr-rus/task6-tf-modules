resource "aws_vpc" "AWS-VPC" {
   cidr_block       = "10.90.0.0/16"
  //cidr_block = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "AWS-TR-VPC"
  }

  lifecycle {
    ignore_changes = [cidr_block, instance_tenancy]
  }
}

resource "aws_subnet" "AWS-subnet" {
  vpc_id     = aws_vpc.AWS-VPC.id
  cidr_block = "10.90.90.0/24"

  tags = {
    Name = "AWS-subnet"
  }
}

resource "aws_route_table" "AWS-RouteTable" {
  vpc_id = aws_vpc.AWS-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.AWS-InternetGateway.id
  }
}

resource "aws_route_table_association" "assoc-1" {
  subnet_id      = aws_subnet.AWS-subnet.id
  route_table_id = aws_route_table.AWS-RouteTable.id
}

resource "aws_internet_gateway" "AWS-InternetGateway" {
  tags = {
    Name = "AWS-TR-Internet-Gateway"
  }

  vpc_id = aws_vpc.AWS-VPC.id
}