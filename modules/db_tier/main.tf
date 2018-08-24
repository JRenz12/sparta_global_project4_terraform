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



# create an association
resource "aws_route_table_association" "db_1a_association" {
  subnet_id      = "${aws_subnet.db_1a.id}"
  route_table_id = "${var.app_route_table}"
}

resource "aws_route_table_association" "db_1b_association" {
  subnet_id      = "${aws_subnet.db_1b.id}"
  route_table_id = "${var.app_route_table}"
}

resource "aws_route_table_association" "db_1c_association" {
  subnet_id      = "${aws_subnet.db_1c.id}"
  route_table_id = "${var.app_route_table}"
}

# security
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "security group for db"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = ["${var.app_security_group}"]
    cidr_blocks = ["0.0.0.0/0"]
    self = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self = true
  }
}


# launch an instance
resource "aws_instance" "db_1a" {
  ami           = "${var.db_ami_id}"
  subnet_id     = "${aws_subnet.db_1a.id}"
  private_ip = "10.10.4.7"
  user_data = "${data.template_file.filebeats_server.rendered}"
  security_groups = ["${aws_security_group.db_sg.id}"]
  instance_type = "t2.micro"
  key_name = "${var.key}"
  associate_public_ip_address = true
  provisioner "local-exec" {
  command = "export LC_ALL=C",
  command = "mongo --eval 'rs.initiate()'",
  command = "mongo --eval 'rs.add('10.10.5.7')'",
  command = "mongo --eval 'rs.add('10.10.6.7')'",
  command = "mongo --eval 'db.isMaster()'",
  command = "mongo --eval 'rs.slaveOk()'"]
    connection {
      user = "ubuntu"
      password = "Acad3my1"
      private_key = "${var.private_key}"
    }
  }
  tags {
      Name = "${var.name}-1a"
  }
}

resource "aws_instance" "db_1b" {
  ami           = "${var.db_ami_id}"
  subnet_id     = "${aws_subnet.db_1b.id}"
  private_ip = "10.10.5.7"
  user_data = "${data.template_file.filebeats_server.rendered}"
  security_groups = ["${aws_security_group.db_sg.id}"]
  instance_type = "t2.micro"

  tags {
      Name = "${var.name}-1b"
  }
}

resource "aws_instance" "db_1c" {
  ami           = "${var.db_ami_id}"
  subnet_id     = "${aws_subnet.db_1c.id}"
  private_ip = "10.10.6.7"
  user_data = "${data.template_file.filebeats_server.rendered}"
  security_groups = ["${aws_security_group.db_sg.id}"]
  instance_type = "t2.micro"
  tags {
      Name = "${var.name}-1c"
  }
}

resource "aws_instance" "db_provisioner" {
  ami           = "ami-0a416218b24c2f41f"
  subnet_id     = "${aws_subnet.db_1a.id}"
  private_ip = "10.10.4.8"
  security_groups = ["${aws_security_group.db_sg.id}"]
  instance_type = "t2.micro"
  user_data = "${data.template_file.db_provisioner_tmplt.rendered}"
  tags {
      Name = "${var.name}-provisioner"
  }
}

# load the db template
data "template_file" "db_provisioner_tmplt" {
   template = "${file("./scripts/app/db.sh.tpl")}"
   vars {
   public_ip = "${aws_instance.db_1a.public_ip}"
   }
}

data "template_file" "filebeats_server" {
   template = "${file("./scripts/app/filebeats.sh.tpl")}"
}
