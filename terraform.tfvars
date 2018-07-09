# cidr blocks

// cidr = {
//     "private_cidr" = "192.168.1.0/24"
//     "public_cidr" = "192.168.101.0/24"
//     "db_cidr" = "92.168.102.0/24"
// }
region = "eu-west-1"

azs = [
  "eu-west-1a",
  "eu-west-1b",
]

cidr = "192.168.0.0/22"

public_subnets = [
  "192.168.0.0/25",
  "192.168.0.128/25",
]

private_subnets = [
  "192.168.1.0/25",
  "192.168.1.128/25",
]

db_subnets = [
  "192.168.2.0/25",
  "192.168.2.128/25",
]

// remote_access = "my_ipaddess"


# See readme


# stack_name = "mytest"


# bastion_remote_access_ssh = [
#   "x.x.x.x/32,description",
# ]


# ssh_public_key = "ssh-rsa fakdshfahdsfkljadsfjklahdskfljhasdklfjhadjklsfhaklsdghjakljsdfhgaksjdf;aksdhjfkajdhsfklajhsdfakldhjsf rd@nasa"


# bastion_instance_size = "t2.xlarge"


# app_instance_size = "t2.xlarge"


# web_instance_size = "t2.xlarge"


# db_multi_az = false


# db_name = "example_database"


# db_user = "example"


# db_passwd = "supersecretpassword"


# deploy_bucket = "rbexamplebuiltbin"


# //default ssm key
# app_ssm_kms_key = "alias/aws/ssm"

