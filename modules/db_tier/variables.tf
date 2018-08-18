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

variable "app_route_table" {
  description = "internet gateway for vpc"
}
