provider "aws" {
  region = "eu-west-1"
}


# ROUTE 53 RECORD TO APP
resource "aws_route53_record" "manvir" {
  zone_id = "Z3CCIZELFLJ3SC"
  name    = "kiran.spartaglobal.education"
  type    = "CNAME"
  ttl     = "300"
  records = ["${module.app.elb_app}"]
}


## TEMPLATE
data "template_file" "app_user_data" {
template = "${file("${path.cwd}/template/app/user_data.sh.tpl")}"
}

module "app" {
  source = "./modules/app_tier"
  vpc_id = "${module.app.vpc_id}"
  name = "APP-PROJECT4"
  app_ami_id = "${module.app.app_ami_id}"
  cidr_block = "14.10.0.0/16"
  user_data = "${data.template_file.app_user_data.rendered}"
  elk_security_group = "${module.elk.elk_security_group}"
}

#module "db" {
#  source = "./modules/db_tier"
#  vpc_id = ""
#  name = "DB-PROJECT4"
#  app_ami_id = ""
#  cidr_block = ""
#  user_data = ""
#}


module "elk" {
  source = "./modules/elk_tier"
  cidr_block = "14.10.0.0/16"
  key = "DevOpsStudents"
  private_key = "${file("~/.ssh/DevOpsStudents.pem")}"
  vpc_id = "${module.app.vpc_id}"
}
