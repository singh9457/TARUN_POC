resource "aws_instance" "analytics_api_server_instance" {
	instance_type = "${var.instance_types["analytics_api"]}"	
	ami = "${var.ec2_ami["analytics_api"]}"	
	key_name = "${var.aws_key_pair_name}"			
	subnet_id = "${aws_subnet.pub_subnet_c.id}"
	vpc_security_group_ids = ["${aws_security_group.analytics_api_server_sg.id}"]	
	disable_api_termination = "true"
		
	root_block_device {
		volume_type           = "gp2"
		volume_size           = "${var.ec2_vol_size}"
		delete_on_termination = "true"
	}	
	volume_tags {
		"Instance Name" = "${var.product_tag}-${var.environment_tag}-${var.name_tags["analytics_api_server"]}"
		"Product Name" = "${var.product_tag}"
		"Project Code" = "${var.project_tag}"
		"Project Manager" = "${var.other_tags["Proj_mgr"]}"
		Approver = "${var.other_tags["approver"]}"
		Environment = "${var.environment_tag}"
		Billing = "${var.other_tags["billing"]}"
		"Resource Type" = "EBS Volume"
		"End Date" = "${var.other_tags["end_date"]}"
		Owner = "${var.owner_tag}"
		Name = "${var.product_tag}-${var.environment_tag}-${var.name_tags["analytics_api_server"]}"
	}
	tags {
		"Instance Name" = "${var.product_tag}-${var.environment_tag}-${var.name_tags["analytics_api_server"]}"
		"Product Name" = "${var.product_tag}"
		"Project Code" = "${var.project_tag}"
		"Project Manager" = "${var.other_tags["Proj_mgr"]}"
		Approver = "${var.other_tags["approver"]}"
		Environment = "${var.environment_tag}"
		Billing = "${var.other_tags["billing"]}"
		"Resource Type" = "EC2 Instance"
		"End Date" = "${var.other_tags["end_date"]}"
		Owner = "${var.owner_tag}"
		Name = "${var.product_tag}-${var.environment_tag}-${var.name_tags["analytics_api_server"]}"
	}
}


#Security Group for Analytics API Server
resource "aws_security_group" "analytics_api_server_sg" {
  name        = "${var.product_tag}-${var.environment_tag}-Analytics-api-sg"
  description = "Security Group for ${var.product_tag}-${var.environment_tag} Analytics API Server SG"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = "3000"
    to_port     = "3005"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks =  ["61.16.177.190/32","61.16.241.78/32","49.248.66.190/32","61.16.241.91/32","61.16.182.106/32","111.93.180.174/32"]
	description = "ssh access from learningmate"
  }   
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["${var.devops_vpc_cidr}"]
	description = "ssh access from build server network"
  } 
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
	"Instance Name" = "${var.product_tag}-${var.environment_tag}-analytics-api-server-db-sg"
	"Project Code" = "${var.project_tag}"
	"Project Manager" = "${var.other_tags["Proj_mgr"]}"
	Approver = "${var.other_tags["approver"]}"
	Environment = "${var.environment_tag}"
	Billing = "${var.other_tags["billing"]}"
	"Resource Type" = "Security Group"
	"End Date" = "${var.other_tags["end_date"]}"
	Owner = "${var.owner_tag}"
	Name = "${var.product_tag}-${var.environment_tag}-analytics-api-server-db-sg"
  }
}

resource "aws_eip" "ananlytics_api_server_eip" {
  instance = "${aws_instance.analytics_api_server_instance.id}"
  vpc      = true
}


#OUTPUTS
output "analytics_api_ec2_instance_id" {
  value = "${aws_instance.analytics_api_server_instance.id}"
}

output "analytics_api_ec2_public_ip" {
  value = "${aws_instance.analytics_api_server_instance.public_ip}"
}

output "analytics_api_ec2_private_ip" {
  value = "${aws_instance.analytics_api_server_instance.private_ip}"
}

#Create Parameter Store
resource "aws_ssm_parameter" "analytics_api_ec2_private_ip" {
  name  = "/${var.environment_tag}/${var.product_tag}/analytics_api_ec2_private_ip"
  type  = "String"
  value = "${aws_instance.analytics_api_server_instance.private_ip}"
  overwrite = "true"
  tags = {
    Environment = "${var.environment_tag}"
	"Product Name" = "${var.product_tag}"
	"Project Code" = "${var.project_tag}"
	"Project Manager" = "${var.other_tags["Proj_mgr"]}"
	"Project Code" = "${var.project_tag}"
  }
}
