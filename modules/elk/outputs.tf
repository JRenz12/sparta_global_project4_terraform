output "kibana_url" {
  value = "http://${aws_eip.ip.public_ip}:5601"
  description = "URL to your ELK server's Kibana web page"
}
output "vpc_id" {
  #value = "${aws_vpc.main_vpc.id}"
  value = "${aws_default_vpc.default.id}"
}
