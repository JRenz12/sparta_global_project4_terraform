output "vpc_id" {
  value = "${aws_vpc.app.id}"
}

output "app_ami_id" {
  value = "ami-c2b8bfbb"
}

output "db_ami_id" {
  value = "ami-01020378"
}
