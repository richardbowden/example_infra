resource "aws_security_group" "db" {
  name        = "db_cluster"
  description = "allow inbound access from ${aws_security_group.app.name}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    security_groups = ["${aws_security_group.app.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name} - db servers"
  }
}

resource "aws_security_group" "web" {
  name = "web_servers"

  //   description = "allow inbound access from ${aws_security_group..name}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = ["${aws_security_group.super_secure_bastion.id}", "${aws_security_group.web_elb.id}"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

    # security_groups = ["${aws_security_group.super_secure_bastion.id}", "${aws_security_group.web_elb.id}"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.super_secure_bastion.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name} - web servers"
  }
}

resource "aws_security_group" "app" {
  name        = "app_servers"
  description = "allow inbound access from ${aws_security_group.web.name}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 8081
    to_port         = 8081
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web.id}"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.super_secure_bastion.id}"]
  }

  ingress {
    from_port       = 8081
    to_port         = 8081
    protocol        = "tcp"
    security_groups = ["${aws_security_group.super_secure_bastion.id}"]
  }

  ingress {
    from_port       = 8081
    to_port         = 8081
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app_elb.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name} - app servers"
  }
}
