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
