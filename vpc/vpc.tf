resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr}"

  tags {
    Name = "${var.name}"
  }
}

resource "aws_subnet" "public" {
  availability_zone       = "${element(var.azs, count.index)}"
  cidr_block              = "${element(var.public_subnets, count.index)}"
  map_public_ip_on_launch = true
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.azs)}"

  tags {
    Name = "public - ${var.name} - ${element(var.azs, count.index)}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${var.name} - public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
  count          = "${length(var.azs)}"
}

resource "aws_subnet" "private" {
  availability_zone       = "${element(var.azs, count.index)}"
  cidr_block              = "${element(var.private_subnets, count.index)}"
  map_public_ip_on_launch = false
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.azs)}"

  tags {
    Name = "private - ${var.name} - ${element(var.azs, count.index)}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_eip" "nat_eips" {
  count = "${length(var.azs)}"
  vpc   = true
}

resource "aws_nat_gateway" "ngw" {
  count = "${length(var.azs)}"

  allocation_id = "${element(aws_eip.nat_eips.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  depends_on    = ["aws_internet_gateway.igw"]

  tags {
    Name = "private subnet - ${element(var.azs, count.index)}"
  }
}

resource "aws_route" "private_nat_gw" {
  count                  = "${length(var.azs)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.ngw.*.id, count.index)}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table" "private" {
  count  = "${length(var.azs)}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "private - ${var.name} - ${element(var.azs, count.index)}"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  count          = "${length(var.azs)}"
}

resource "aws_subnet" "db" {
  availability_zone       = "${element(var.azs, count.index)}"
  cidr_block              = "${element(var.db_subnets, count.index)}"
  map_public_ip_on_launch = false
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.azs)}"

  tags {
    //add the zone for humans
    Name = "db - ${var.name} - ${element(var.azs, count.index)}"

    // environment = "${var.tag_environment}"
  }
}

resource "aws_route_table" "db" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.name} - db"
  }
}

resource "aws_route_table_association" "db" {
  subnet_id      = "${element(aws_subnet.db.*.id, count.index)}"
  route_table_id = "${aws_route_table.db.id}"
  count          = "${length(var.azs)}"
}
