provider "aws" {
  region = "eu-west-1"
}

    ## VPC
resource "aws_vpc" "main_vpc" {
  cidr_block       = "${var.cidr_block}"
  tags {
    Name = "app-vpc"
  }
}




    ## ROUTE TABLE
resource "aws_route_table" "app_route_table" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.app_intenet_gateway.id}"
  }

  tags {
    Name = "app-route-table"
  }
}

resource "aws_route_table_association" "app_route_association" {
  subnet_id      = "${aws_subnet.app_subnet.id}"
  route_table_id = "${aws_route_table.app_route_table.id}"
}



    ## INTERNET GATEWAY
resource "aws_internet_gateway" "app_intenet_gateway" {
  vpc_id = "${var.vpc_id}"
  tags {
    Name = "main"
  }
}


      ## SUBNET
resource "aws_subnet" "app_subnet" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "10.10.1.0/24"
  availability_zone = "eu-west-1a"
  tags {
    Name = "subnet-app-manvir"
  }
}


    ## SECURITY GROUP
resource "aws_security_group" "app_security_group" {
  name        = "app-sg"
  description = "security group for app"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


    ## INSTANCE
resource "aws_instance" "app_instance_1a" {
  ami = "${var.app_ami_id}"
  instance_type = "t2.micro"
  user_data = "${var.user_data}"
  subnet_id = "${aws_subnet.app_subnet.id}"
  security_groups = ["${aws_security_group.app_security_group.id}"]
  associate_public_ip_address = true
  tags {
    Name = "app-instance-1a"
  }
}
