# # Configure the AWS Provider
# provider "aws" {
#   region = "us-east-1"
#   access_key = "access_key"
#   secret_key = "access_key"
# }

# # Create a VPC
# resource "aws_vpc" "my-vpc" {

#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "my-public-subnet-1" {
#     vpc_id = aws_vpc.my-vpc.id
#     cidr_block = "10.0.1.0/24"
#     availability_zone = "us-east-1a"
#     map_public_ip_on_launch = true
# }
# resource "aws_subnet" "my-private-subnet-1" {
#     vpc_id = aws_vpc.my-vpc.id
#     cidr_block = "10.0.2.0/24"
#     availability_zone = "us-east-1a"
#     map_public_ip_on_launch = true
# }

# resource "aws_subnet" "my-public-subnet-2" {
#     vpc_id = aws_vpc.my-vpc.id
#     cidr_block = "10.0.3.0/24"
#     availability_zone = "us-east-1b"
#     map_public_ip_on_launch = true
# }
# resource "aws_subnet" "my-private-subnet-2" {
#     vpc_id = aws_vpc.my-vpc.id
#     cidr_block = "10.0.4.0/24"
#     availability_zone = "us-east-1b"
#     map_public_ip_on_launch = true
# }
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.my-vpc.id

#   # tags = {
#   #   Name = "my-igw"
#   # }
# }
# resource "aws_route_table" "public_subnet_rt" {
#   vpc_id = aws_vpc.my-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
  
#   }
# }

# resource "aws_route_table_association" "public_subnet_association_1"{
#   subnet_id = aws_subnet.my-public-subnet-1.id
#   route_table_id = aws_route_table.public_subnet_rt.id
# }

# resource "aws_route_table_association" "public_subnet_association_2"{
#   subnet_id = aws_subnet.my-public-subnet-2.id
#   route_table_id = aws_route_table.public_subnet_rt.id
# }
# resource "aws_eip" "nat_eip" {
#   tags = {
#     Name = "my-nat-eip"
#   }
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.my-public-subnet-1.id

#   tags = {
#     Name = "my-nat-gateway"
#   }
# }
# resource "aws_route_table" "NAT-Gateway-RT" {
#   depends_on = [
#     aws_nat_gateway.nat
#   ]

#   vpc_id = aws_vpc.my-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }

#   tags = {
#     Name = "Route Table for NAT Gateway"
#   }

# }

# resource "aws_route_table_association" "private_subnet_association1" {
#   depends_on = [ aws_route_table.NAT-Gateway-RT ]
#   subnet_id = aws_subnet.my-private-subnet-1.id
#   route_table_id = aws_route_table.NAT-Gateway-RT.id

# }
# resource "aws_route_table_association" "private_subnet_association2" {
#   subnet_id = aws_subnet.my-private-subnet-2.id
#   route_table_id = aws_route_table.NAT-Gateway-RT.id
# }

# resource "aws_security_group" "sg"{
#   vpc_id = aws_vpc.my-vpc.id
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "web-sg"
#   }
# }

# output "vpc_id"{
#   value = aws_vpc.my-vpc.id
# }
# output "public_subnet_1_id" {
#   value = aws_subnet.my-public-subnet-1.id
# }

# output "public_subnet_2_id" {
#   value = aws_subnet.my-public-subnet-2.id
# }

# output "private_subnet_1_id" {
#   value = aws_subnet.my-private-subnet-1
# }

# output "private_subnet_2_id" {
#   value = aws_subnet.my-private-subnet-2
# }

# output "security_group_id" {
#   value = aws_security_group.sg.id
# }


