output "db_ami_id" {
  value = "ami-0ce380b886769d3a8"
}

output "db_private_ip_a" {
  value = "${aws_instance.db_1a.private_ip}"
}

output "db_private_ip_b" {
  value = "${aws_instance.db_1b.private_ip}"
}

output "db_private_ip_c" {
  value = "${aws_instance.db_1c.private_ip}"
}
