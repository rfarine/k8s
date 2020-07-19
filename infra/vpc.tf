#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "rae" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
      "Name", "terraform-eks-k8s",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "rae" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.rae.id}"

  tags = "${
    map(
      "Name", "terraform-eks-k8s",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "rae" {
  vpc_id = "${aws_vpc.rae.id}"

  tags = {
    Name = "terraform-eks-rae"
  }
}

resource "aws_route_table" "rae" {
  vpc_id = "${aws_vpc.rae.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.rae.id}"
  }
}

resource "aws_route_table_association" "rae" {
  count = 2

  subnet_id      = "${aws_subnet.rae.*.id[count.index]}"
  route_table_id = "${aws_route_table.rae.id}"
}
