//bastion does not have an iam role, as it shold not be allowed to access AWS directly, this is just a method 
//to get access to internal servers for troubleshooting
resource "aws_instance" "bastion" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_size}"
  key_name               = "${var.key}"
  subnet_id              = "${var.subnet}"
  vpc_security_group_ids = ["${var.sgs}"]
  user_data              = "${var.user_data}"

  tags {
    Name = "${var.name} - bastion"
  }
}
