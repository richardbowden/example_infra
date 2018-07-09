
# cidr blocks

// cidr = {
//     "private_cidr" = "192.168.1.0/24"
//     "public_cidr" = "192.168.101.0/24"
//     "db_cidr" = "92.168.102.0/24"
// }
region = "eu-west-1"

azs = [
    "eu-west-1a",
    "eu-west-1b"
]

cidr = "192.168.0.0/22"

public_subnets = [
    "192.168.0.0/25", 
    "192.168.0.128/25"
]

private_subnets = [
    "192.168.1.0/25", 
    "192.168.1.128/25"
]

db_subnets = [
    "192.168.2.0/25",
    "192.168.2.128/25"
]