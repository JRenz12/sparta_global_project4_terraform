## TEMPLATE FOR APP
data "template_file" "app_user_data" {
template = "${file("${path.module}/scripts/app/init.sh.tpl")}"
}

module "app" {
  source = "modules/app_tier"
  vpc_id = "${module.app.vpc_id}"
  name = "APP-PROJECT4"
  app_ami_id = "${module.app.app_ami_id}"
  cidr_block = "10.10.0.0/16"
  user_data = "${data.template_file.app_user_data.rendered}"
}

module "db" {
  source = "modules/db_tier"
  vpc_id = "${module.app.vpc_id}"
  name = "DB-PROJECT4"
  app_security_group = "${module.app.app_security_group}"
  db_ami_id = "${module.db.db_ami_id}"
  db_private_ip_a = "${module.db.db_private_ip_a}"
  db_private_ip_b = "${module.db.db_private_ip_b}"
  db_private_ip_c = "${module.db.db_private_ip_c}"

#  cidr_block = ""
}
