resource "aws_security_group" "app_elb" {
  name = "app_elb"

  //   description = "allow inbound access from ${aws_security_group..name}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = ["${aws_security_group.super_secure_bastion.id}", "${aws_security_group.web.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name} - app elb"
  }
}

resource "aws_security_group" "web_elb" {
  name = "web_elb"

  //   description = "allow inbound access from ${aws_security_group..name}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name} - web elb"
  }
}
