output "kibana_url" {
  value       = "http://${aws_eip.ip.public_ip}:5601"
  description = "URL to your ELK server's Kibana web page"
}

output "elk_security_group" {
  description = "elk security group"
  value = "${aws_security_group.elk_security_group.id}"
}

output "key"{
  value = "DevOpsStudents"
}

output "private_key"{
  value = "${file("~/.ssh/DevOpsStudents.pem")}"
}
