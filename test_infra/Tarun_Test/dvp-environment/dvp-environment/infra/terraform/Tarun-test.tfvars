aws_region = "us-east-1"

public_endpoints = "true"

#this will require if public_endpoints is true
devops_jenkins_master_public_ip = "3.222.138.198"

#this will require if public_endpoints is true"
devops_jenkins_slave_public_ip = "18.233.16.28"

account_id = "597270402194"

build_server_cidr = {
	master = "sg-0885574550b14804c"
	slave = "sg-04ff954f5ab8d3863"	
}

devops_vpc_id = "vpc-0b0cd1cab68b135d3"

devops_route_table_id = "rtb-02e7c19c8d0b48c38"

devops_vpc_cidr = "10.0.0.0/16"

vpc_cidr = "192.150.0.0/16"

subnet_cidr {
    pub_a = "192.150.1.0/24"
    pub_c = "192.150.2.0/24"
    pvt_a = "192.150.3.0/24"
    pvt_c = "192.150.4.0/24"
}		

domain_name = "cerifi.io"


ssl_cert_arn {
	cdn = "arn:aws:acm:us-east-1:597270402194:certificate/5b90647a-d62a-4804-bebc-a197e5218e9d"
}


resource "aws_instance" "example" {
  ami           = "your-ami-id"
  instance_type = "t2.micro"
  tags = {
    Name = "ExampleInstance"
  }
}

cdn_alias = {
        lms_portal_ui ="cfi04-lms-qa.cerifi.io"
      
}

bucket_name_prifix = {
	lms_portal_assets = "lms-assets"
        lms_portal_ui = "lms-ui"
        lms_lambda = "lms-potal-lambda"
        
}


project_tag = "TEST"
environment_tag = "devtest"
product_tag = "TEST"
owner_tag = "DevOps Team"
other_tags {
	proj_code = "EMDD"
	Proj_mgr = "Pradyumna,pujari"
	approver = "Pradyumna,pujari"
  
}