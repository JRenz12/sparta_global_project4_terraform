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

## Declare the data source
data "aws_availability_zones" "available" {}

    ## SUBNETS
resource "aws_subnet" "app_subnet_1a" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "10.10.0.0/24"
  availability_zone = "eu-west-1a"
  tags {
    Name = "subnet-app-project4"
  }
}

resource "aws_subnet" "app_subnet_1b" {
vpc_id     = "${var.vpc_id}"
cidr_block = "10.10.1.0/24"
availability_zone = "eu-west-1b"
tags {
  Name = "subnet-app-project4"
}
}

resource "aws_subnet" "app_subnet_1c" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "10.10.2.0/24"
  availability_zone = "eu-west-1c"
  tags {
    Name = "subnet-app-project4"
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
  subnet_id      = "${aws_subnet.app_subnet_1a.id}"
  route_table_id = "${aws_route_table.app_route_table.id}"
}



    ## INTERNET GATEWAY
resource "aws_internet_gateway" "app_intenet_gateway" {
  vpc_id = "${var.vpc_id}"
  tags {
    Name = "main"
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
resource "aws_instance" "app_instance" {
  ami = "${var.app_ami_id}"
  instance_type = "t2.micro"
  user_data = "${var.user_data}"
  subnet_id = "${aws_subnet.app_subnet_1a.id}"
  security_groups = ["${aws_security_group.app_security_group.id}"]
  associate_public_ip_address = true
  tags {
    Name = "app-instance-1a"
  }
}

  ## AUTO SCALING GROUP

resource "aws_launch_template" "app_launch_template" {
  name_prefix = "Project4-launch"
  image_id = "ami-c2b8bfbb"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "app_auto_scaling" {
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  desired_capacity = 3
  max_size = 4
  min_size = 3

  launch_template = {
    id = "${aws_launch_template.app_launch_template.id}"
    version = "$$Latest"
  }
}

    ## ELB
resource "aws_elb" "elb_app" {
  name = "elb-app"
  security_groups = ["${aws_security_group.app_security_group.id}"]
  subnets = ["${aws_subnet.app_subnet_1a.id}", "${aws_subnet.app_subnet_1b.id}", "${aws_subnet.app_subnet_1c.id}"]

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:8080/"
  }
    listener {
      lb_port = 80
      lb_protocol = "http"
      instance_port = "8080"
      instance_protocol = "http"
    }
}
