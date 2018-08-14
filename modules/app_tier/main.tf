provider "aws" {
  region = "eu-west-1"
}


resource "aws_route53_record" "engineering12" {
  zone_id = "Z3CCIZELFLJ3SC"
  name    = "engineering12.spartaglobal.education"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_elb.elb_app.dns_name}"]
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

resource "aws_route_table_association" "elb_association" {
  subnet_id      = "${aws_subnet.elb_subnet.id}"
  route_table_id = "${aws_route_table.app_route_table.id}"
}



    ## SUBNETS
#1a
resource "aws_subnet" "app_subnet_1a" {
  vpc_id     = "${var.vpc_id}"
<<<<<<< HEAD
  cidr_block = "10.10.1.0/24"
  availability_zone = "eu-west-1a"
=======
  cidr_block = "10.10.0.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

>>>>>>> 258fa0efadeb9a6af2fcf3fb115fe975016da155
  tags {
    Name = "subnet-app-1a"
  }
}

#1b
resource "aws_subnet" "app_subnet_1b" {
  vpc_id     = "${var.vpc_id}"
<<<<<<< HEAD
  cidr_block = "10.10.2.0/24"
  availability_zone = "eu-west-1b"
  tags {
    Name = "subnet-app-1b"
=======
  cidr_block = "10.10.1.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags {
    Name = "subnet-app-project4"
>>>>>>> 258fa0efadeb9a6af2fcf3fb115fe975016da155
  }
}

#1c
resource "aws_subnet" "app_subnet_1c" {
  vpc_id     = "${var.vpc_id}"
<<<<<<< HEAD
  cidr_block = "10.10.3.0/24"
  availability_zone = "eu-west-1c"
=======
  cidr_block = "10.10.2.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"
>>>>>>> 258fa0efadeb9a6af2fcf3fb115fe975016da155
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
     from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.elb_security_group.id}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

  ## INSTANCE

    ## INSTANCE


resource "aws_launch_template" "applaunch_template" {
  name = "Project4-launch-manvir"
  image_id = "ami-c2b8bfbb"
  instance_type = "t2.micro"
  user_data = "${data.template_file.app_user_data.rendered}"
  network_interfaces {
    security_groups = ["${aws_security_group.app_security_group.id}"]
  }
}

resource "aws_autoscaling_group" "app_auto_scaling" {
  load_balancers = ["${aws_elb.elb_app.id}"]
  desired_capacity = 3
  max_size = 4
  min_size = 3
  vpc_zone_identifier = ["${aws_subnet.app_subnet_1a.id}", "${aws_subnet.app_subnet_1b.id}","${aws_subnet.app_subnet_1c.id}"]
  launch_template = {
    id = "${aws_launch_template.applaunch_template.id}"
  }

}

    ## ELB
resource "aws_elb" "elb_app" {
  name = "elb-app-manvir"
  security_groups = ["${aws_security_group.elb_security_group.id}"]
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
  #template to run the app
  data "template_file" "app_user_data" {
  template = "${file("template/app/user_data.sh.tpl")}"
}
