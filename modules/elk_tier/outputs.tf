output "kibana_url" {
  value       = "http://${aws_instance.elk_manvir.private_dns}:5601"
  description = "URL to your ELK server's Kibana web page"
}

output "elk_security_group" {
  description = "elk security group"
  value = "${aws_security_group.elk_security_group.id}"
}
