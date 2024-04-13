provider "aws" {
  region = "${var.aws_region}"
  #profile = "${var.aws_profile}"  
  #access_key = "${var.aws_creds["AK_ID"]}"
  #secret_key = "${var.aws_creds["SK_ID"]}"
}

#OUTPUTS
output "aws_region" {
  value = "${var.aws_region}"
}

output "aws_account_id" {
  value = "${var.account_id}"
}


#Create Parameter Store
resource "aws_ssm_parameter" "aws_region" {
  name  = "/${var.environment_tag}/${var.product_tag}/aws_region"
  type  = "String"
  value = "${var.aws_region}"
  overwrite = "true"
  tags = {
    Environment = "${var.environment_tag}"
	"Product Name" = "${var.product_tag}"
	"Project Code" = "${var.project_tag}"
	"Project Manager" = "${var.other_tags["Proj_mgr"]}"
	"Project Code" = "${var.project_tag}"
  }
}