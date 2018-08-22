    ## VPC
resource "aws_vpc" "main_vpc" {
  cidr_block  = "${var.cidr_block}"
  enable_dns_hostnames = true
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
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "subnet-app-project4"
  }
}

resource "aws_subnet" "app_subnet_1b" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "10.10.1.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags {
    Name = "subnet-app-project4"
  }
}

resource "aws_subnet" "app_subnet_1c" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "10.10.2.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"
  tags {
    Name = "subnet-app-project4"
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


resource "aws_route_table_association" "app_1a_association" {
  subnet_id      = "${aws_subnet.app_subnet_1a.id}"
  route_table_id = "${aws_route_table.app_route_table.id}"
}

resource "aws_route_table_association" "app_1b_association" {
  subnet_id      = "${aws_subnet.app_subnet_1b.id}"
  route_table_id = "${aws_route_table.app_route_table.id}"
}

resource "aws_route_table_association" "app_1c_association" {
  subnet_id      = "${aws_subnet.app_subnet_1c.id}"
  route_table_id = "${aws_route_table.app_route_table.id}"
}


    ## INTERNET GATEWAY
resource "aws_internet_gateway" "app_internet_gateway" {
  vpc_id = "${var.vpc_id}"
  tags {
    Name = "main"
  }
}


    ## SECURITY GROUPS
resource "aws_security_group" "app_security_group" {
  name        = "app-sg"
  description = "security group for app"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.elb_security_group.id}","${var.elk_security_group}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "elb_security_group" {
  name        = "elb-sg"
  description = "security group for elb"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["$var.db_sg"]
    self = true
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



  ## APP LAUNCH TEMPLATE

resource "aws_launch_template" "app_launch_template" {
  name_prefix = "Project4-launch"
  image_id = "ami-c2b8bfbb"
  instance_type = "t2.micro"
  user_data = "${var.user_data}"
  network_interfaces {
    security_groups = ["${aws_security_group.app_security_group.id}"]
  }
}


  ## AUTO SCALING GROUP
resource "aws_autoscaling_group" "app_auto_scaling" {
  load_balancers = ["${aws_elb.elb_app.id}"]
  health_check_type = "ELB"
  health_check_grace_period = "240"
  desired_capacity = 3
  max_size = 4
  min_size = 3
  vpc_zone_identifier = ["${aws_subnet.app_subnet_1a.id}", "${aws_subnet.app_subnet_1b.id}","${aws_subnet.app_subnet_1c.id}"]
  launch_template = {
    id = "${aws_launch_template.app_launch_template.id}"
    version = "$$Latest"
  }
  tags = [
    {
      key                 = "name"
      value               = "APP_instance"
      propagate_at_launch = true
    },
  ]


}

    ## ELB
resource "aws_elb" "elb_app" {
  name = "elb-app"
  security_groups = ["${aws_security_group.elb_security_group.id}"]
  subnets = ["${aws_subnet.app_subnet_1a.id}", "${aws_subnet.app_subnet_1b.id}", "${aws_subnet.app_subnet_1c.id}"]

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 240
    target = "HTTP:80/"
  }
    listener {
      lb_port = 80
      lb_protocol = "http"
      instance_port = "80"
      instance_protocol = "http"
    }
  }
