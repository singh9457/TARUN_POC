# Create a s3 bucket for LMS Launch Front end app
resource "aws_s3_bucket" "lms_bucket_app" {
bucket = "${var.project_tag}-${var.environment_tag}-${var.bucket_name_prifix["lms_portal_ui"]}-website"
acl = "public-read"
force_destroy = false
website {
index_document = "index.html"
error_document = "error.html"
}
cors_rule {
allowed_headers = ["Authorization","Content-Length"]
allowed_methods = ["GET", "PUT", "POST"]
allowed_origins = ["*"]
expose_headers = ["ETag"]
max_age_seconds = 3000
}
tags {
    "Project Code" = "${var.project_tag}"
    "Project Manager" = "${var.other_tags["Proj_mgr"]}"
    Approver = "${var.other_tags["approver"]}"
    Environment = "${var.environment_tag}"
    Billing = "${var.other_tags["billing"]}"
    "Resource Type" = "S3 Bucket"
    "End Date" = "${var.other_tags["end_date"]}"
    Owner = "${var.owner_tag}"
}
}

resource "aws_s3_bucket_policy" "lms_bucket_policy" {
bucket = "${aws_s3_bucket.lms_bucket_app.id}"
policy =<<POLICY
{
"Version":"2012-10-17",
"Statement":[
{
    "Sid":"PublicReadForGetBucketObjects",
"Effect":"Allow",
    "Principal": "*",
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::${aws_s3_bucket.lms_bucket_app.id}/*"
]
}
]
}
POLICY
}

#OUTPUTS
output "lms_ui_s3_bucket_name" {
value = "${aws_s3_bucket.lms_bucket_app.bucket}"
}

#Create Parameter Store
resource "aws_ssm_parameter" "lms_ui_s3_bucket_name" {
  name  = "/${var.environment_tag}/${var.product_tag}/lms_ui_s3_bucket_name"
  type  = "String"
  value = "${aws_s3_bucket.lms_bucket_app.bucket}"
  overwrite = "true"
  tags = {
    Environment = "${var.environment_tag}"
	"Product Name" = "${var.product_tag}"
	"Project Code" = "${var.project_tag}"
	"Project Manager" = "${var.other_tags["Proj_mgr"]}"
	"Project Code" = "${var.project_tag}"
  }
}
