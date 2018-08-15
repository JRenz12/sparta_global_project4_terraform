variable "vpc_id" {
  description = "the vpc to launch the resource info"
}

variable "name" {
  description = "name of db-tier resources"
}

variable "app_security_group" {
  description = "application's security group"
}

variable "db_ami_id" {
  description = "mongodb ami"
}

variable "db_private_ip_a" {
  description = "private ip 1a"
}

variable "db_private_ip_b" {
  description = "private ip 1b"
}

variable "db_private_ip_c" {
  description = "private ip 1c"
}
