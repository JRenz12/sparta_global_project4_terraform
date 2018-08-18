variable "vpc_id" {
  description = "the vpc to launch the resource info"
}
variable "name" {
  description = "the vpc to launch the resource info"
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

variable "app_names" {
  default = {
    "0" = "app_1a"
    "1" = "app_1b"
    "2" = "app_1c"
  }
}
