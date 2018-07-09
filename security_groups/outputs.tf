output "bastion_sg_id" {
  value = "${aws_security_group.super_secure_bastion.*.id}"
}

output "web_sg_id" {
  value = "${aws_security_group.web.id}"
}

output "app_sg_id" {
  value = "${aws_security_group.app.id}"
}

output "db_sg_id" {
  value = "${aws_security_group.db.id}"
}

output "app_elb_sg_id" {
  value = "${aws_security_group.app_elb.id}"
}

output "web_elb_sg_id" {
  value = "${aws_security_group.web_elb.id}"
}

output "bastion_sg_name" {
  value = "${aws_security_group.super_secure_bastion.*.name}"
}
