resource "aws_vpc" "elk_vpc" {
  cidr_block       = "10.11.0.0/16"
  tags {
    Name = "elk-vpc"
  }
}

resource "aws_vpc_peering_connection" "elk_peering" {
  peer_vpc_id   = "${aws_vpc.elk_vpc.id}"
  vpc_id        = "${var.vpc_id}"
  auto_accept   = true
}

resource "aws_subnet" "elk_subnet" {
  vpc_id     = "${aws_vpc.elk_vpc.id}"
  cidr_block = "10.11.0.0/24"
  tags {
    Name = "elk-subnet"
  }
}


resource "aws_security_group" "elk_security_group" {
  name = "allow_elk"
  description = "All all elasticsearch traffic"
  vpc_id = "${aws_vpc.elk_vpc.id}"

  # elasticsearch port
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # logstash port
  ingress {
    from_port   = 5043
    to_port     = 5044
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # kibana ports
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_instance" "elk_manvir" {
  ami           = "ami-031831702eaf214b0"
  subnet_id     = "${aws_subnet.elk_subnet.id}"
  private_ip = "10.10.4.7"
  security_groups = ["${aws_security_group.elk_security_group.id}"]
  instance_type = "t2.micro"
  associate_public_ip_address = true
  tags {
      Name = "elk-manvir-1a"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.elk_manvir.id}"
}
