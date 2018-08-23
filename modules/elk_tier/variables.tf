variable "key" {
  description = "Name of the AWS Key Pair to associate with the ELK instance."
}
variable "private_key" {
  description = "Path to the local SSH private key file associated with the AWS Key Pair."
}

variable "cidr_block" {
  description = "the vpc to launch the resource info"
}

variable "vpc_id" {
  description = "vpc id for main vpc"
}

variable "app_route_table" {
  description = "app route table"
}
