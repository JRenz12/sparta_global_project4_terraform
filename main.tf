
provider "aws" {
  region = "eu-west-1"
}

module "elk" {
  source = "./modules/elk"
  cidr_block = "14.10.0.0/16"
  vpc_id = "${module.elk.vpc_id}"
  key = "DevOpsStudents"
  private_key = "${file("~/.ssh/DevOpsStudents.pem")}"
  #key = "id_rsa"
  #private_key = "${file("~/.ssh/id_rsa")}"
}

resource "aws_default_vpc" "default" {
  tags {
      Name = "Default VPC"
  }
}
