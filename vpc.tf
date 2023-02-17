# vpc create
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"                # can be change as per recuirement
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy = "default"
  tags = {
    Name = "any_name"
  }
}

# internet gateway creation
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "any_name"
  }
}

# Public subnet creation
resource "aws_subnet" "pub_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-south-1a"             # can be change as per recuirement
  cidr_block              = "10.0.0.0/24"             # can be change as per recuirement
  map_public_ip_on_launch = true
  depends_on = [
    aws_vpc.vpc
  ]
  tags = {
    "Name" = "pub_subnet"
  }
}

# Private Subnet creation
resource "aws_subnet" "pri_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-south-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
  tags = {
    "Name" = "pri_subnet"
  }
}

# route table creation
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    "Name" = "routeForEcs"
  }
}

resource "aws_route_table_association" "route_table_association" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.pub_subnet.id
}


# security group creation
resource "aws_security_group" "ecs_sg" {
  name = "ec2_sg"
  vpc_id = aws_vpc.vpc.id

# for ssh connection in ec2
  ingress {                 
    from_port   = 22            
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# https access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# container port in which application will run
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# outbound rules
  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }

  tags={
    Name = "any_name"
  } 

}