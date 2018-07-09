resource "aws_security_group" "super_secure_bastion" {
  name        = "bastion_server"
  description = "allows admin access - locked down to ip"
  vpc_id      = "${var.vpc_id}"
  count       = "${length(var.bastion_remote_access_ssh)}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${element(split(",", element(var.bastion_remote_access_ssh, count.index)), 0)}"]
    description = "${element(split(",", element(var.bastion_remote_access_ssh, count.index)), 1)}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name} - bastion server"
  }
}
