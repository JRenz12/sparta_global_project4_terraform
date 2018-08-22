output "vpc_id" {
  value = "${aws_vpc.main_vpc.id}"
}

output "app_ami_id" {
  value = "ami-c2b8bfbb"
}

output "app_security_group" {
  value = "${aws_security_group.app_security_group.id}"
}

output "elb_app" {
  description = "elb of app"
  value = "${aws_elb.elb_app.dns_name}"
}

output "app_route_table" {
  description = "internet gateway for app"
  value = "${aws_route_table.app_route_table.id}"
}
