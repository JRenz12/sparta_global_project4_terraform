provider "aws" {
  region = "eu-west-1"
}

# load the db template
data "template_file" "db_tmplt" {

   template = "${file("./scripts/app/db.sh.tpl")}"
   vars {
     db_1a = "10.10.4.1:27017"
   }
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

  tags {
    Name = "${var.name}-sg"
  }
}

resource "aws_security_group_rule" "mongodb_ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.db_sg.id}"
}

resource "aws_security_group_rule" "mongodb_mongodb" {
  type            = "ingress"
  from_port       = 27017
  to_port         = 27017
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.db_sg.id}"
}

resource "aws_security_group_rule" "mongodb_mongodb_replication" {
  type            = "ingress"
  from_port       = 27019
  to_port         = 27019
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.db_sg.id}"
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
  private_ip = "10.10.4.1"
  instance_type = "t2.micro"
  user_data = "${data.template_file.db_tmplt.rendered}"
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
