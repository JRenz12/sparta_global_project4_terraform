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

variable "key" {
  description = "Name of the AWS Key Pair to associate with the ELK instance."
}
variable "private_key" {
  description = "Path to the local SSH private key file associated with the AWS Key Pair."
}
