output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "db_subnets" {
  value = ["${aws_subnet.db.*.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

// DO NOT REMOVE this is to force a dependancy between this and the autoscaling groups, this is just annoying you cannot not have modual dependancies
output "nat_gateway_ip" {
  value = "${element(aws_nat_gateway.ngw.*.public_ip, 1)}"
}
