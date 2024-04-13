resource "aws_vpc_peering_connection" "devops_vpc_peer" {
  peer_owner_id = "${var.account_id}"
  peer_vpc_id   = "${var.devops_vpc_id}"
  vpc_id        = "${aws_vpc.vpc.id}"
  auto_accept   = true

  tags = {
    Name = "${var.project_tag}-${var.environment_tag}-${var.product_tag}-vpc-peering"
  }
}

resource "aws_route" "jenkins_to_app" {
  route_table_id = "${var.devops_route_table_id}"
  destination_cidr_block = "${aws_vpc.vpc.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.devops_vpc_peer.id}"
}

resource "aws_route" "pub_app_to_jenkins" {
  route_table_id = "${aws_route_table.pub_route_table.id}"
  destination_cidr_block = "${var.devops_vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.devops_vpc_peer.id}"
}

resource "aws_route" "pvt_app_to_jenkins" {
  route_table_id = "${aws_route_table.pvt_route_table.id}"
  destination_cidr_block = "${var.devops_vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.devops_vpc_peer.id}"
}