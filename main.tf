## TEMPLATE

data "template_file" "app_user_data" {
  template = "${file("${path.module}/templates/app/user_data.sh.tpl")}"
  vars {
    db_host = "mongodb://10.10.5.0/24:27017/posts"
  }
}


module "app" {
  source = "modules/app_tier"
  vpc_id = "${module.app.vpc_id}"
  name = "APP-PROJECT4"
  app_ami_id = "${module.app.app_ami_id}"
  cidr_block = "10.10.0.0/16"
  app_user_data = "${data.template_file.app_user_data.rendered}"
}

#module "db" {
#  source = "./modules/db_tier"
#  vpc_id = ""
#  name = "DB-PROJECT4"
#  app_ami_id = ""
#  cidr_block = ""
#  user_data = ""
#}
