provider "aws" {
  region = "eu-west-1"
}


# create a subnet
resource "aws_subnet" "db_subnet" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "10.10.4.0/24"
  availability_zone = "eu-west-1a"
  tags {
    Name = "${var.name} - 1a"
  }
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
    self = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/24"]
  }
}




# launch an instance
resource "aws_instance" "db_1a" {
  ami = "ami-01020378"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.db_subnet.id}"
  private_ip = "10.10.4.7"
  security_groups = ["${aws_security_group.db_sg.id}"]
  tags {
    Name = "Manvir-db"
  }
}




# load the db template
data "template_file" "db_tmplt" {

   template = "${file("./scripts/app/db.sh.tpl")}"
   vars {
    db_1a_privateip = "10.10.4.7"
   }

}
