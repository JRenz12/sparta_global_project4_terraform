provider "aws" {
  region = "eu-west-1"
}

# create a subnet
resource "aws_subnet" "db_1a" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "10.10.4.0/24"
  map_public_ip_on_launch = false
  availability_zone = "eu-west-1a"
  tags {
    Name = "${var.name} - 1a"
  }
}

resource "aws_subnet" "db_1b" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "10.10.5.0/24"
  map_public_ip_on_launch = false
  availability_zone = "eu-west-1b"
  tags {
    Name = "${var.name} - 1b"
  }
}

resource "aws_subnet" "db_1c" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "10.10.6.0/24"
  map_public_ip_on_launch = false
  availability_zone = "eu-west-1c"
  tags {
    Name = "${var.name} - 1c"
  }
}

# security
resource "aws_security_group" "db_sg"  {
  name = "${var.name}-sg"
  description = "${var.name} access"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = "27017"
    to_port         = "27017"
    protocol        = "tcp"
    security_groups = ["${var.app_security_group}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}-sg"
  }
}

# public route table
resource "aws_route_table" "db_rt" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.name}-rt"
  }
}

resource "aws_route_table_association" "db_1a" {
  subnet_id      = "${aws_subnet.db_1a.id}"
  route_table_id = "${aws_route_table.db_rt.id}"
}

resource "aws_route_table_association" "db_1b" {
  subnet_id      = "${aws_subnet.db_1b.id}"
  route_table_id = "${aws_route_table.db_rt.id}"
}

resource "aws_route_table_association" "db_1c" {
  subnet_id      = "${aws_subnet.db_1c.id}"
  route_table_id = "${aws_route_table.db_rt.id}"
}

# launch an instance
resource "aws_instance" "db_1a" {
  ami           = "${var.db_ami_id}"
  subnet_id     = "${aws_subnet.db_1a.id}"
  vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
  #private_ip = "10.10.4.1"
  instance_type = "t2.micro"
  tags {
      Name = "${var.name}-1a"
  }
}

resource "aws_instance" "db_1b" {
  ami           = "${var.db_ami_id}"
  subnet_id     = "${aws_subnet.db_1b.id}"
  vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
  instance_type = "t2.micro"
  tags {
      Name = "${var.name}-1b"
  }
}

resource "aws_instance" "db_1c" {
  ami           = "${var.db_ami_id}"
  subnet_id     = "${aws_subnet.db_1c.id}"
  vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
  instance_type = "t2.micro"
  tags {
      Name = "${var.name}-1c"
  }
}
