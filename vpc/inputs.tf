variable "name" {}
variable "cidr" {}

variable "azs" {
    type="list"
}

variable "public_subnets" {
    type="list"
}
variable "private_subnets" {
    type="list"
}
variable "db_subnets" {
    type="list"
}

// variable "bastion_static_sshaccess" {
//   type = "list"
// }
