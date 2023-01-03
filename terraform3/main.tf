#*******creating vpc***********

resource "aws_vpc" "vpc_01" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "vpc_01"
  }
}

resource "aws_vpc" "vpc_02" {
  provider   = aws.singapore
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "vpc_02"
  }
}

#***********creating IGW***********

resource "aws_internet_gateway" "Igw-01" {
  vpc_id = aws_vpc.vpc_01.id
  tags = {
    Name = "Igw-01"
  }
}

#**********creating public subnet**********

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc_01.id
  availability_zone = element(var.azs, 1)
  cidr_block        = var.public_subnet
  tags = {
    Name = "Public_subnet"
  }
}

#**********create Route table***************

resource "aws_route_table" "public_subnet" {
  vpc_id = aws_vpc.vpc_01.id
  tags = {
    Name = "public_route"
  }
}

#**********attaching IGW to public subnet****************

resource "aws_route" "Igw-01" {
  route_table_id         = aws_route_table.public_subnet.id
  destination_cidr_block = var.Igw
  gateway_id             = aws_internet_gateway.Igw-01.id
}

#***********associating public subnet********************
 
resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_subnet.id
}

#**********creating private subnet**********

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc_01.id
  cidr_block        = var.private_subnet
  availability_zone = element(var.azs, 2)
  tags = {
    Name = "Private_subnet"
  }
}

#**********create Route table***************

resource "aws_route_table" "private_subnet" {
  vpc_id = aws_vpc.vpc_01.id
  tags = {
    Name = "private_route"
  }
}

#**********Creating ngw****************

resource "aws_nat_gateway" "Nat_gw" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.public_subnet.id
  tags = {
    Name = "Nat_gw"
  }
}

#**********attaching NGW to private subnet****************

resource "aws_route" "Nat_gw" {
  route_table_id         = aws_route_table.private_subnet.id
  destination_cidr_block = var.Igw
  nat_gateway_id         = aws_nat_gateway.Nat_gw.id
}

#***********associating private subnet********************

resource "aws_route_table_association" "private_subnet" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_subnet.id
}

#*********creating public instances**************

resource "aws_instance" "public_instance" {
  count                       =   var.instance_type == "public_instance" ? 2 : 0
  ami                         = var.amis[var.region]
  iam_instance_profile        = count.index == 1 ?  aws_iam_instance_profile.usr_madhu.name : ""
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = ["${aws_security_group.zsecurity.id}"]
  tags = {
    "Name" = "public_instance-${count.index + 1}"
  }
}

#*********creating private instances**************

resource "aws_instance" "private_instance" {
  count                       = var.instance_type == "private_instance" ? 0 : 3 
  ami                         = var.amis[var.region]
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids      = ["${aws_security_group.zsecurity.id}"]
  tags = {
    "Name" = "private_instance-${count.index + 1}"
  }
}

#*********creating security groups(default)**************

resource "aws_security_group" "zsecurity" {
  vpc_id = aws_vpc.vpc_01.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "zsecurity"
  }
}

#*********creating iam policy**************

resource "aws_iam_policy" "policy" {
  name        = "bucket_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = [
                  "arn:aws:s3:::madhu",
                  "arn:aws:s3:::madhu/*"]
      },
    ]
  })
}

#*************Create an IAM Role***********
resource "aws_iam_role" "madhu" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "RoleForEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}
#********attaching policy***************

resource "aws_iam_policy_attachment" "madhu_attach" {
  name       = "madhu_attachment"
  roles      = [aws_iam_role.madhu.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "usr_madhu" {
  name = "usr_madhu"
  role = aws_iam_role.madhu.name
}
