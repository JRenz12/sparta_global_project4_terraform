## TEMPLATE


module "app" {
  source = "modules/app_tier"
  vpc_id = "${module.app.vpc_id}"
  name = "APP-PROJECT4"
  app_ami_id = "${module.app.app_ami_id}"
  cidr_block = "10.10.0.0/16"
}

#module "db" {
#  source = "./modules/db_tier"
#  vpc_id = ""
#  name = "DB-PROJECT4"
#  app_ami_id = ""
#  cidr_block = ""
#  user_data = ""
#}
