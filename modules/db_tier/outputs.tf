output "db_ami_id" {
  value = "ami-077dc8ec5032ab904"
}

output "db_1a_privateip" {
  description = "db 1a private ip"
  value = "${aws_instance.db_1a.private_ip}"
}

output "db_1a_sg" {
  description = "db 1a instance id"
  value = "${aws_security_group.db_sg.id}"
}
