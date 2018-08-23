resource "aws_vpc" "elk_vpc" {
  cidr_block       = "10.11.0.0/16"
  tags {
    Name = "elk-vpc"
  }
}


## ROUTE TABLE
resource "aws_route_table" "elk_route_table" {
vpc_id = "${aws_vpc.elk_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.elk_internet_gateway.id}"
  }
  tags {
    Name = "app-route-table"
  }
}


resource "aws_route_table_association" "elk_association" {
  subnet_id      = "${aws_subnet.elk_subnet.id}"
  route_table_id = "${aws_route_table.elk_route_table.id}"
}


resource "aws_internet_gateway" "elk_internet_gateway" {
  vpc_id = "${aws_vpc.elk_vpc.id}"
  tags {
    Name = "main"
  }
}


resource "aws_vpc_peering_connection" "elk_peering" {
  peer_vpc_id   = "${var.vpc_id}"
  vpc_id        = "${aws_vpc.elk_vpc.id}"
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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # logstash port
  #ingress {
  #  from_port   = 5043
  #  to_port     = 5044
  #  protocol    = "tcp"
  #  cidr_blocks = ["0.0.0.0/0"]
  #}

  # kibana ports
  #ingress {
  #  from_port   = 5601
  #  to_port     = 5601
  #  protocol    = "tcp"
  #  cidr_blocks = ["0.0.0.0/0"]
  #}

  # ssh
  #ingress {
  #  from_port   = 22
  #  to_port     = 22
  #  protocol    = "tcp"
  #  cidr_blocks = ["0.0.0.0/0"]
  #}

  # outbound
  #egress {
  #  from_port   = 0
  #  to_port     = 0
  #  protocol    = "-1"
  #  cidr_blocks = ["0.0.0.0/0"]
  #}

}

# load the db template
data "template_file" "elk_tmplt" {
   template = "${file("./scripts/app/elk.sh.tpl")}"
   #vars {
   #public_ip = "${aws_instance.db_1a.public_ip}"
   #}
}

resource "aws_instance" "elk_manvir" {
  ami           = "ami-031831702eaf214b0"
  subnet_id     = "${aws_subnet.elk_subnet.id}"
  private_ip = "10.11.0.7"
  security_groups = ["${aws_security_group.elk_security_group.id}"]
  instance_type = "t2.micro"
  key_name = "${var.key}"
  associate_public_ip_address = true

  provisioner "file" {
    source      = "template/app/02-beats-input.conf"
    destination = "/etc/logstash/conf.d/02-beats-input.conf"
  }
  provisioner "file" {
    source      = "template/app/10-syslog-filter.conf"
    destination = "/etc/logstash/conf.d/10-syslog-filter.conf"
  }
  provisioner "file" {
    source      = "template/app/30-elasticsearch-output.conf"
    destination = "/etc/logstash/conf.d/30-elasticsearch-output.conf"
  }
  user_data = "${data.template_file.elk_tmplt.rendered}"
  tags {
      Name = "elk-manvir-1a"
  }
  connection {
    agent = true
    user = "ubuntu"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.elk_manvir.id}"
}
