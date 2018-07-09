resource "aws_ssm_parameter" "db_password" {
  name        = "/database/passwd"
  description = "db password"
  type        = "SecureString"
  value       = "${var.db_passwd}"

  tags {
    environment = "${var.name}"
  }
}

resource "aws_ssm_parameter" "db_user" {
  name        = "/database/user"
  description = "db user"
  type        = "SecureString"
  value       = "${var.db_user}"

  tags {
    environment = "${var.name}"
  }
}

resource "aws_ssm_parameter" "db_url" {
  name        = "/database/url"
  description = "db url"
  type        = "SecureString"
  value       = "${aws_db_instance.default.endpoint}"

  tags {
    environment = "${var.name}"
  }
}

resource "aws_ssm_parameter" "db_name" {
  name        = "/database/dbname"
  description = "db url"
  type        = "SecureString"
  value       = "${aws_db_instance.default.name}"

  tags {
    environment = "${var.name}"
  }
}
