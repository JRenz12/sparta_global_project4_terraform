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


    ## INTERNET GATEWAY
resource "aws_internet_gateway" "app_internet_gateway" {
  vpc_id = "${var.vpc_id}"
  tags {
    Name = "main"
  }
}


    ## ROUTE TABLE
resource "aws_route_table" "app_route_table" {
  vpc_id = "${var.vpc_id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.app_internet_gateway.id}"
  }
  tags {
    Name = "app-route-table"
  }
}

resource "aws_route_table_association" "elg_association" {
  subnet_id      = "${aws_subnet.elb_subnet.id}"
  route_table_id = "${aws_route_table.app_route_table.id}"
}



    ## SUBNETS
#1a
resource "aws_subnet" "app_subnet_1a" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "10.10.1.0/24"
  availability_zone = "eu-west-1a"
  tags {
    Name = "subnet-app-1a"
  }
}

#1b
resource "aws_subnet" "app_subnet_1b" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "10.10.2.0/24"
  availability_zone = "eu-west-1b"
  tags {
    Name = "subnet-app-1b"
  }
}

#1c
resource "aws_subnet" "app_subnet_1c" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "10.10.3.0/24"
  availability_zone = "eu-west-1c"
  tags {
    Name = "subnet-app-1c"
  }
}

#elb-subnet
resource "aws_subnet" "elb_subnet" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "10.10.4.0/24"
  availability_zone = "eu-west-1a"
  tags {
    Name = "subnet-elb-project4"
  }
}



    ## SECURITY GROUPS

#elb-security-group
resource "aws_security_group" "elb_security_group" {
  name        = "elb-security-group"
  description = "security group for elb"
  vpc_id      = "${aws_vpc.main_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_security_group" {
  name        = "app-sg"
  description = "security group for app"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = ["${aws_security_group.elb_security_group.id}"]
    cidr_blocks = ["10.10.4.0/24"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

  ## INSTANCE

      ## AUTO SCALING GROUP
data "template_file" "app_user_data" {
  template = "${file("${path.cwd}/templates/app/user_data.sh.tpl")}"
  vars {
    db_host = "mongodb://10.10.4.0/24:27017/posts"
  }
}

data "template_cloudinit_config" "master" {
  base64_encode = true
  # get common user_data
  part {
    filename     = "common.cfg"
    content_type = "text/part-handler"
    content      = "${data.template_file.app_user_data.rendered}"
  }
}



resource "aws_autoscaling_group" "app_auto_scaling" {
  load_balancers = ["${aws_elb.elb_app.id}"]
  desired_capacity = 3
  max_size = 4
  min_size = 3
  vpc_zone_identifier = ["${aws_subnet.app_subnet_1a.id}","${aws_subnet.app_subnet_1b.id}","${aws_subnet.app_subnet_1c.id}"]
  
}

    ## ELB
resource "aws_elb" "elb_app" {
  name = "elb-app-manvir"
  security_groups = ["${aws_security_group.app_security_group.id}"]
  subnets = ["${aws_subnet.app_subnet_1a.id}", "${aws_subnet.app_subnet_1b.id}", "${aws_subnet.app_subnet_1c.id}"]
  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
    listener {
      lb_port = 80
      lb_protocol = "http"
      instance_port = "80"
      instance_protocol = "http"
    }
}
