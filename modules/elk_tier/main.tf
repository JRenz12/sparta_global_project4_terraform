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
