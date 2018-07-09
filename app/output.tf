output "app_elb_dns_name" {
  value = "${aws_elb.elb_app.dns_name}"
}

output "is_internal" {
  value = "${aws_elb.elb_app.internal}"
}
