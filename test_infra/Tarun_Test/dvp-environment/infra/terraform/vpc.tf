#Main VPC detail
resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "${var.project_tag}-${var.environment_tag}-${var.product_tag}-vpc"
  }
}

#Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
        Name =  "${var.project_tag}-${var.environment_tag}-${var.product_tag}-igw"
  }
}

#Route table for public subnets
resource "aws_route_table" "pub_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  
  tags = {
    Name =  "${var.project_tag}-${var.environment_tag}-${var.product_tag}-pub_igw"
  }
}

#Set main route table
resource "aws_main_route_table_association" "main_rt" {
  vpc_id         = "${aws_vpc.vpc.id}"
  route_table_id = "${aws_route_table.pub_route_table.id}"
}

#Creating Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.igw"]
  tags = {
        Name =  "${var.project_tag}-${var.environment_tag}-${var.product_tag}-nat-gw"
  }
}

#Creating NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
    allocation_id = "${aws_eip.nat_eip.id}"
    subnet_id = "${aws_subnet.pub_subnet_a.id}"
    depends_on = ["aws_internet_gateway.igw"]
}


#Create a public subnet A
resource "aws_subnet" "pub_subnet_a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_cidr["pub_a"]}"
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_region}a"
  tags = {
        Name =  "${var.project_tag}-${var.environment_tag}-${var.product_tag}-pub_subnet_a"
  }
}

# Create public subnet C
resource "aws_subnet" "pub_subnet_c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_cidr["pub_c"]}"
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_region}c"
  tags = {
        Name =  "${var.project_tag}-${var.environment_tag}-${var.product_tag}-pub_subnet_c"
  }
}

#Route table subnet associations public subnet a
resource "aws_route_table_association" "pub_a" {
  subnet_id      = "${aws_subnet.pub_subnet_a.id}"
  route_table_id = "${aws_route_table.pub_route_table.id}"
}

#Route table subnet associations public subnet c
resource "aws_route_table_association" "pub_c" {
  subnet_id      = "${aws_subnet.pub_subnet_c.id}"
  route_table_id = "${aws_route_table.pub_route_table.id}"
}

#Route Table with NAT
resource "aws_route_table" "pvt_route_table" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name =  "${var.project_tag}-${var.environment_tag}-${var.product_tag}-pvt-nat"
    }
}

#Route for NAT 
resource "aws_route" "nat_route" {
	route_table_id  = "${aws_route_table.pvt_route_table.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
}

#Create a private subnet in A
resource "aws_subnet" "pvt_subnet_a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_cidr["pvt_a"]}"
  availability_zone = "${var.aws_region}a"
  tags = {
        Name =  "${var.project_tag}-${var.environment_tag}-${var.product_tag}-pvt_subnet_a"
  }
}

# Create private subnet in C
resource "aws_subnet" "pvt_subnet_c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_cidr["pvt_c"]}"
  availability_zone = "${var.aws_region}c"
  tags = {
        Name =  "${var.project_tag}-${var.environment_tag}-${var.product_tag}-pvt_subnet_c"
  }
}

#Route table subnet associations private A
resource "aws_route_table_association" "pvt_a" {
  subnet_id      = "${aws_subnet.pvt_subnet_a.id}"
  route_table_id = "${aws_route_table.pvt_route_table.id}"
}

#Route table subnet associations private C
resource "aws_route_table_association" "pvt_c" {
  subnet_id      = "${aws_subnet.pvt_subnet_c.id}"
  route_table_id = "${aws_route_table.pvt_route_table.id}"
}

#VPC s3 endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.vpc.id}"
  service_name = "com.amazonaws.${var.aws_region}.s3"
}

#Associate Route Table with endpoint
resource "aws_vpc_endpoint_route_table_association" "endpoint_route_table_association" {
  route_table_id  = "${aws_route_table.pvt_route_table.id}"
  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
}


#OUTPUTS
output "pvt_subnet_a_id" {
  value = "${aws_subnet.pvt_subnet_a.id}"
}

output "pvt_subnet_c_id" {
  value = "${aws_subnet.pvt_subnet_c.id}"
}

#Create Parameter Store
resource "aws_ssm_parameter" "pvt_subnet_a_id" {
  name  = "/${var.environment_tag}/${var.product_tag}/pvt_subnet_a_id"
  type  = "String"
  value = "${aws_subnet.pvt_subnet_a.id}"
  overwrite = "true"
  tags = {
    Environment = "${var.environment_tag}"
	"Product Name" = "${var.product_tag}"
	"Project Code" = "${var.project_tag}"
	"Project Manager" = "${var.other_tags["Proj_mgr"]}"
	"Project Code" = "${var.project_tag}"
  }
}

#Create Parameter Store
resource "aws_ssm_parameter" "pvt_subnet_c_id" {
  name  = "/${var.environment_tag}/${var.product_tag}/pvt_subnet_c_id"
  type  = "String"
  value = "${aws_subnet.pvt_subnet_c.id}"
  overwrite = "true"
  tags = {
    Environment = "${var.environment_tag}"
	"Product Name" = "${var.product_tag}"
	"Project Code" = "${var.project_tag}"
	"Project Manager" = "${var.other_tags["Proj_mgr"]}"
	"Project Code" = "${var.project_tag}"
  }
}