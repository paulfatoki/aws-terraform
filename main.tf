# vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-server-VPC"
  }
}
# internetgateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my-server-IGW"
  }
}
# public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-server-Public-Subnet"
  }
}
# private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "my-server-Private-Subnet"
  }
}
# route table for public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my-server-Public-RT"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
# route table for private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my-server-Private-RT"
  }
}

# route table association
# (NAT Gateway and Elastic IP resources here...but left out for now)

# Associate Public Route Table with Public Subnet

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate Private Route Table with Private Subnet
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# EC2 Instance in the Public Subnet
resource "aws_instance" "web_public" {
  ami                    = "ami-04a81a99f5ec58529"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  user_data              = file("user-data.sh")
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  key_name               = "jen"
  tags = {
    Name = "my-server-Public"
  }
}

# EC2 Instance in the Private Subnet
#By default when not defined associate_public_ip_address = false
resource "aws_instance" "web_private" {
  ami                    = "ami-04a81a99f5ec58529"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  key_name               = "jen"
  tags = {
    Name = "my-server-Private"
  }
}




