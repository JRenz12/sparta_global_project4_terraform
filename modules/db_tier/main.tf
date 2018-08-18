provider "aws" {
  region = "eu-west-1"
}


# create a subnet
resource "aws_subnet" "db_1a" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "10.10.4.0/24"
  availability_zone = "eu-west-1a"
  tags {
    Name = "${var.name} - 1a"
  }
}

resource "aws_subnet" "db_1b" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "10.10.5.0/24"
  availability_zone = "eu-west-1b"
  tags {
    Name = "${var.name} - 1b"
  }
}

resource "aws_subnet" "db_1c" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "10.10.6.0/24"
  availability_zone = "eu-west-1c"
  tags {
    Name = "${var.name} - 1c"
  }
}

# security
resource "aws_security_group" "db_security_group" {
  name        = "db-sg"
  description = "security group for db"
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



# launch an instance
resource "aws_instance" "db_1a" {
  ami           = "${var.db_ami_id}"
  subnet_id     = "${aws_subnet.db_1a.id}"
  private_ip = "10.10.4.7"
  vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]
  instance_type = "t2.micro"
  user_data = "${data.template_file.db_tmplt.rendered}"
  tags {
      Name = "${var.name}-1a"
  }
}

resource "aws_instance" "db_1b" {
  ami           = "${var.db_ami_id}"
  subnet_id     = "${aws_subnet.db_1b.id}"
  private_ip = "10.10.5.7"
  vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]
  instance_type = "t2.micro"
  tags {
      Name = "${var.name}-1b"
  }
}

resource "aws_instance" "db_1c" {
  ami           = "${var.db_ami_id}"
  subnet_id     = "${aws_subnet.db_1c.id}"
  private_ip = "10.10.6.7"
  vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]
  instance_type = "t2.micro"
  tags {
      Name = "${var.name}-1c"
  }
}



# load the db template
data "template_file" "db_tmplt" {

   template = "${file("./scripts/app/db.sh.tpl")}"
   vars {
    db_1a_privateip = "http://10.10.4.7"
    db_1b_privateip = "${aws_instance.db_1b.private_ip}"
    db_1c_privateip = "${aws_instance.db_1c.private_ip}"
   }

}
