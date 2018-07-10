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

variable "nodes_min" {}

variable "nodes_max" {}

variable "nodes_desired_capacity" {}

variable "elb_sg_id" {}

variable "nat_gateway_ip" {}

variable "param_store_db_url_path" {}

variable "deploy_bucket" {}
variable "deploy_file" {}

variable "app_ssm_kms_key" {}

variable "region" {}
