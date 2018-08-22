output "vpc_id" {
  value = "${aws_vpc.main_vpc.id}"
}

output "app_ami_id" {
  value = "ami-c2b8bfbb"
}

<<<<<<< HEAD
output "app_security_group" {
  value = "${aws_security_group.app_security_group.id}"
}

=======
>>>>>>> 328f1008947b2d371b06453d2e6c432ad02591d7
output "elb_app" {
  description = "elb of app"
  value = "${aws_elb.elb_app.dns_name}"
}
<<<<<<< HEAD

output "app_route_table" {
  description = "internet gateway for app"
  value = "${aws_route_table.app_route_table.id}"
}
=======
>>>>>>> 328f1008947b2d371b06453d2e6c432ad02591d7
