output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "db_subnets" {
  value = "${module.vpc.db_subnets}"
}

output "public_subnets" {
  value = ["${module.vpc.public_subnets}"]
}

output "private_subnets" {
  value = ["${module.vpc.private_subnets}"]
}

output "bastion_sg_id" {
  value = "${element(module.security_groups.bastion_sg_id,1)}"
}

output "bastion_sg_name" {
  value = "${element(module.security_groups.bastion_sg_name,1)}"
}

output "web_sg_id" {
  value = "${module.security_groups.web_sg_id}"
}

output "app_sg_id" {
  value = "${module.security_groups.app_sg_id}"
}

output "db_sg_id" {
  value = "${module.security_groups.db_sg_id}"
}

output "app_elb_sg_id" {
  value = "${module.security_groups.app_elb_sg_id}"
}

output "web_elb_sg_id" {
  value = "${module.security_groups.web_elb_sg_id}"
}

output "app_elb_is_internal" {
  value = "${module.app.is_internal}"
}

output "web_elb_is_internal" {
  value = "${module.web.is_internal}"
}
