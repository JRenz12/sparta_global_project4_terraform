resource "aws_vpc" "elk_vpc" {
  cidr_block       = "${var.cidr_block}"
  tags {
    Name = "elk-vpc"
  }
}
