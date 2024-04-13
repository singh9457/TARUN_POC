variable "aws_region" {
  description = "AWS region to launch servers."
}

variable "public_endpoints" {
	description = "true will launch rds and ec2 in public subnets"
	default = "false"
}

variable "is_quad_needed" {
	description = "true if you need quad infrastructure"
	default = "true"
}

variable "devops_jenkins_master_public_ip" {
	description = "this will require if public_endpoints is true"
	default = "3.216.109.255"
}
variable "devops_jenkins_slave_public_ip" {
	description = "this will require if public_endpoints is true"
	default = "3.220.100.218"
}

variable "aws_creds" {
	description = "aws access and secret keys"
	default = {
		AK_ID = "XXXXXXXXXXXXXX"
		SK_ID = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
	}
}

variable "account_id" {
  description = "AWS Account ID"
}


variable "vpc_cidr" {
  description = "VPC CIDR for infrastructure"
}

variable "subnet_cidr" {
  description = "subnet cidr in vpc"
  default = {
		pub_a = "192.168.1.0/24"
		pub_c = "192.168.2.0/24"
		pvt_a = "192.168.3.0/24"
		pvt_c = "192.168.4.0/24"
	}
}

variable "domain_name" {
  description = "domain name"
  default = "xxx.com"
}

variable "ap_auth_server_password" {
  description = "identity server oauth server password"
  default = "P@ssw0rd"
}

variable "ssl_cert_arn" {
  description = "ARN id of ssl certificates"
  default = {
		cdn = "xxxx"
		elb = "xxxx"
  }
}

variable "cdn_alias" {
	description = "Alias for cdn"
	default = {
		
		Tarun_portal_ui = "tarun.test.com" 
		
	}
}

variable "bucket_name_prifix" {
	description = "Bucket names prifix"
	default = {
		Test_portal_ui = ""Test-ui"
	}
}

variable "instance_types" {
	description = "instance types"
	default = {
		Test_api = "t2.micro"
}

variable "ec2_ami" {
	description = "ec2 ami ids"
	default = {
		frostlor_api = "ami-xxxxxx"
		frostlor_ebs = "ami-xxxxxx"
		quad = "ami-xxxxxx"
	}
}


variable "ec2_vol_size" {
	default = "100"
}



variable "elastic_search" {
	description = "details of elastic search to be launched"
	default = {
		es_ver = "6.7"
		instance_type = "t2.small.elasticsearch"
		instance_count = "1"
		volume_size = "10"
		max_clause_count = "8192"		
	}
}



variable "devops_vpc_id" {
	description = "vpc id of jenkins build servers for peering"
	default = "vpc-0646a21ae8beeb514"
}

variable "devops_route_table_id" {
	description = "route table id of vpc of jenkins build server for peering"
	default = "rtb-0c93ece1762fa4d79"
}

variable "devops_vpc_cidr" {
	description = "CICDR of vpc of jenkins build server for peering and access"
	default = "10.0.0.0/16"
}


variable "name_tags" {
  description = "Name tags for resources"
  default = {
    rds_instance = "TEST RDS Instance"
	cdn = "CloudFront CDN"
  }
}


variable "frostlor_asset_domain_name" {
	description = "TEST"
	default = "XXX-assets.s3.amazonaws.com"
}



variable "project_tag" {
	default = "TEST"
}
variable "environment_tag" {
    default = "test"
}
variable "product_tag" {
	default = "test"
}
variable "owner_tag" {
	default = "DevOps Team"
}

variable "other_tags" {
	description = "Other tags"
	default = {
		project_tag = "TEST"
environment_tag = "devtest"
product_tag = "TEST"
owner_tag = "DevOps Team"
other_tags {
	proj_code = "EMDD"
	Proj_mgr = "Pradyumna,pujari"
	approver = "Pradyumna,pujari"
}

