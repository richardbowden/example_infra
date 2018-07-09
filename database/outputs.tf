output "param_store_db_url_path" {
  value = "${aws_ssm_parameter.db_url.name}"
}
