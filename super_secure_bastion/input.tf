variable "name" {}

variable "key" {}

variable "subnet" {}

variable "ami" {}

variable "sgs" {
  type = "list"
}

variable "instance_size" {}

variable "user_data" {}
