resource "aws_db_subnet_group" "subnet" {
  name       = "main"
  subnet_ids = ["${var.db_subnets}"]

  tags {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage           = 20
  allow_major_version_upgrade = false
  storage_type                = "gp2"
  engine                      = "postgres"
  engine_version              = "9.6"
  instance_class              = "db.t2.micro"
  name                        = "initdatabase"
  final_snapshot_identifier   = "final-${var.name}"
  username                    = "${var.db_user}"
  password                    = "${var.db_passwd}"
  db_subnet_group_name        = "${aws_db_subnet_group.subnet.name}"
  multi_az                    = "${var.db_multi_az}"
  name                        = "${var.db_name}"

  vpc_security_group_ids = ["${var.sgs}"]
}
