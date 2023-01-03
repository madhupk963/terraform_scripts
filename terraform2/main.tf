resource "aws_vpc" "myvpc" {
  cidr_block           = "195.60.10.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "myvpc"
    Environment = "mydev"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.myvpc.id}"
  tags = {
    Name        = "myinternet"
    Environment = "mydev"
  }
}


resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.myvpc.id}"
  cidr_block              = "195.60.10.0/25"
  tags = {
    Name        = "mypublicsubnet"
    Environment = "mydev"
  }
}


resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.myvpc.id}"
  cidr_block              = "195.60.10.128/25"
  tags = {
    Name        = "myprivatesubnet"
    Environment = "mydev"
  }
}

resource "aws_nat_gateway" "nat" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.public_subnet.id
}
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.myvpc.id}"
  tags = {
    Name        = "myprivate"
    Environment = "mydev"
  }
}
/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.myvpc.id}"
  tags = {
Name        = "mypublic"
    Environment = "mydev"
  }
}
resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.ig.id}"
}
resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}
resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "private" {
subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.private.id}"
}
resource "aws_instance" "ec2_public" {
  count = 5
  ami                         = "ami-07ffb2f4d65357b42"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "mumbai_keypair"
  subnet_id                   = "${aws_subnet.public_subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.SG.id}"]

  tags = {
    "Name" = "terraform_demo"
  }

}
resource "aws_security_group" "SG" {
  name                   = "my instances"
  vpc_id                 = "${aws_vpc.myvpc.id}"
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
  tags = {
      "Name" = "My SG"
  }
}
