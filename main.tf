# provider
provider "aws" {
 access_key = var.AWS_ACCESS_KEY
 secret_key = var.AWS_SECRET_KEY
 region = "eu-west-3"
}
# Variables
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

# Creating VPC
resource "aws_vpc" "myapp-vpc"{
    cidr_block = var.vpc_cidr_block
    tags={
        Name: "${var.env_prefix}-vpc"
    }
}

# Creating subnet
resource "aws_subnet" "myapp-subnet-1"{
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone =var.avail_zone
    tags ={
        Name= "${var.env_prefix}-subnet-1"
    }
}

# # creating route table
/*resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags={
    Name= "${var.env_prefix}-rtb"
  }
}*/

# Creating Internet gateway
resource "aws_internet_gateway" "myapp-igw" {
   vpc_id = aws_vpc.myapp-vpc.id
    tags={
    Name= "${var.env_prefix}-igw"
  }
    
}

# # Creaing Route table association
# resource "aws_route_table_association" "a-rtb-subnet" {
#   subnet_id = aws_subnet.myapp-subnet-1.id
#   route_table_id = aws_route_table.myapp-route-table.id
# }

# Using default route table

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags={
    Name= "${var.env_prefix}-main-rtb"
  }

}