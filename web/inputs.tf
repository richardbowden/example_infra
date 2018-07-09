variable "name" {}
variable "key" {}

variable "subnets" {
  type = "list"
}

variable "ami" {}

variable "sgs" {
  type = "list"
}

variable "instance_size" {}
variable "user_data" {}
variable "app_elb_dns_name" {}

variable "nodes_min" {}

variable "nodes_max" {}

variable "nodes_desired_capacity" {}

variable "elb_sg_id" {}
