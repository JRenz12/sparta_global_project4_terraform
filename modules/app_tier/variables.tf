variable "vpc_id" {
  description = "the vpc to launch the resource info"
}
variable "name" {
  description = "the vpc to launch the resource info"
}

variable "key" {
  description = "Name of the AWS Key Pair to associate with the ELK instance."
}
variable "private_key" {
  description = "Path to the local SSH private key file associated with the AWS Key Pair."
}

variable "app_ami_id" {
  description = "the vpc to launch the resource info"
}

variable "cidr_block" {
  description = "the vpc to launch the resource info"
}

variable "user_data" {
  description = "the vpc to launch the resource info"
}

variable "elk_security_group" {
  description = "the elk security group"
}

variable "db_sg" {
  description = "the db security group"
}
