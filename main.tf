provider "aws" {
  region = "${var.region}"
}

variable "region_zone_map" {
  default = {
    "eu-west-1" = {
      "0" = "eu-west-1a"
      "1" = "eu-west-1b"
    }
  }
}

variable "stack_name" {}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "db_subnets" {
  type = "list"
}

variable "region" {}

variable "cidr" {}

variable "azs" {
  type = "list"
}

variable "bastion_remote_access_ssh" {
  type = "list"
}

variable "ssh_public_key" {}

variable "bastion_instance_size" {
  default = "t2.micro"
}

variable "app_instance_size" {
  default = "t2.micro"
}

variable "db_multi_az" {
  default = false
}

variable "db_name" {}

variable "db_user" {}

variable "db_passwd" {}

variable "app_nodes_min" {
  default = 2
}

variable "app_nodes_max" {
  default = 2
}

variable "app_nodes_desired_capacity" {
  default = 2
}

variable "web_nodes_min" {
  default = 2
}

variable "web_nodes_max" {
  default = 2
}

variable "web_nodes_desired_capacity" {
  default = 2
}

variable "web_instance_size" {
  default = "t2.micro"
}

//for a prod deployment, you would use multipul keys, if used at all.
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "${var.ssh_public_key}"
}

data "aws_ami" "base_ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

module "vpc" {
  source          = "./vpc"
  name            = "${var.stack_name}"
  cidr            = "${var.cidr}"
  public_subnets  = "${var.public_subnets}"
  private_subnets = "${var.private_subnets}"
  db_subnets      = "${var.db_subnets}"
  azs             = "${var.azs}"
}

module "security_groups" {
  source                    = "./security_groups"
  name                      = "${var.stack_name}"
  vpc_id                    = "${module.vpc.vpc_id}"
  bastion_remote_access_ssh = "${var.bastion_remote_access_ssh}"
}

module "bastion" {
  source        = "./super_secure_bastion"
  name          = "${var.stack_name}"
  key           = "${aws_key_pair.deployer.id}"
  ami           = "${data.aws_ami.base_ami.id}"
  subnet        = "${element(module.vpc.public_subnets, 0)}"
  instance_size = "${var.bastion_instance_size}"
  sgs           = ["${module.security_groups.bastion_sg_id}"]
  user_data     = "${file("${path.module}/userdata/bastion.sh")}"
}

module "app" {
  source                 = "./app"
  name                   = "${var.stack_name}"
  key                    = "${aws_key_pair.deployer.id}"
  ami                    = "${data.aws_ami.base_ami.id}"
  subnets                = "${module.vpc.private_subnets}"
  instance_size          = "${var.app_instance_size}"
  sgs                    = ["${module.security_groups.app_sg_id}"]
  user_data              = "${file("${path.module}/userdata/app_server.sh")}"
  nodes_min              = "${var.app_nodes_min}"
  nodes_max              = "${var.app_nodes_max}"
  nodes_desired_capacity = "${var.app_nodes_desired_capacity}"
  elb_sg_id              = "${module.security_groups.app_elb_sg_id}"

  //DO NOT REMOVE need to to create a hard dependancy so that the gateways and params are created before the asg's
  nat_gateway_ip = "${module.vpc.nat_gateway_ip}"

  param_store_db_url_path = "${module.database.param_store_db_url_path}"
}

module "web" {
  source                 = "./web"
  name                   = "${var.stack_name}"
  key                    = "${aws_key_pair.deployer.id}"
  ami                    = "${data.aws_ami.base_ami.id}"
  subnets                = "${module.vpc.public_subnets}"
  instance_size          = "${var.web_instance_size}"
  sgs                    = ["${module.security_groups.web_sg_id}"]
  user_data              = "${file("${path.module}/userdata/web_server.tpl")}"
  app_elb_dns_name       = "${module.app.app_elb_dns_name}"
  nodes_min              = "${var.web_nodes_min}"
  nodes_max              = "${var.web_nodes_max}"
  nodes_desired_capacity = "${var.web_nodes_desired_capacity}"
  elb_sg_id              = "${module.security_groups.web_elb_sg_id}"
}

module "database" {
  source      = "./database"
  name        = "${var.stack_name}"
  db_subnets  = "${module.vpc.db_subnets}"
  sgs         = ["${module.security_groups.db_sg_id}"]
  db_multi_az = "${var.db_multi_az}"
  db_name     = "${var.db_name}"
  db_user     = "${var.db_user}"
  db_passwd   = "${var.db_passwd}"
}
