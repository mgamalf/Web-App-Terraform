########################
# VPC
########################
resource "aws_vpc" "nti_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

########################
# SUBNETS
########################
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.nti_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_3" {
  vpc_id                  = aws_vpc.nti_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.nti_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_4" {
  vpc_id            = aws_vpc.nti_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
}

########################
# INTERNET & NAT
########################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.nti_vpc.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_3.id
}

########################
# SECURITY GROUPS
########################
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.nti_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.nti_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################
# AMI
########################
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }
}

########################
# EC2 INSTANCES
########################
resource "aws_instance" "web1" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_2.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data              = file("${path.module}/setup_apache.sh")

  tags = {
    Name = "nti-web-1"
  }
}

resource "aws_instance" "web2" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_4.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data              = file("${path.module}/setup_apache.sh")

  tags = {
    Name = "nti-web-2"
  }
}

########################
# LOAD BALANCER
########################
resource "aws_lb" "alb" {
  name               = "nti-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.public_1.id,
    aws_subnet.public_3.id
  ]
}

resource "aws_lb_target_group" "tg" {
  name     = "nti-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.nti_vpc.id
}

resource "aws_lb_target_group_attachment" "web1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web2.id
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
