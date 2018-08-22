output "db_ami_id" {
  value = "ami-0ce380b886769d3a8"
}

output "db_1a_privateip" {
  description = "db 1a private ip"
  value = "${aws_instance.db_1a.private_ip}"
}

output "db_sg" {
  description = "db 1a instance id"
  value = "${aws_security_group.db_sg.id}"
}
