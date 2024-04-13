resource "aws_cloudfront_origin_access_identity" "lms_assets_origin_access_identity" {
  comment = "${var.product_tag} LMS Portal CF Identity for ${var.environment_tag} environment"
}

resource "aws_cloudfront_distribution" "www_distribution_lms" {
origin {
custom_origin_config {
http_port = "80"
https_port = "443"
origin_protocol_policy = "http-only"
origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
}

domain_name = "${aws_s3_bucket.lms_bucket_app.website_endpoint}"
origin_id = "${aws_s3_bucket.lms_bucket_app.id}"
}


origin {
    domain_name = "${aws_s3_bucket.lms_assets_bucket.bucket_domain_name}"
    origin_id   = "${aws_s3_bucket.lms_assets_bucket.id}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.lms_assets_origin_access_identity.cloudfront_access_identity_path}"
      
	  #origin_access_identity = ""
    }
  }
  

origin {
    domain_name = "${var.frostlor_asset_domain_name}"
    origin_id   = "${var.frosrlor_origin_id}"

    s3_origin_config {
      origin_access_identity = "${var.frostlor-origin_access_identity}"
      
	  #origin_access_identity = ""
    }
  }


enabled = true
comment = "${var.product_tag} ${var.environment_tag} Launch App CDN"
default_root_object = "index.html"

default_cache_behavior {
viewer_protocol_policy = "redirect-to-https"
compress = true
allowed_methods = ["GET", "HEAD"]
cached_methods = ["GET", "HEAD"]
target_origin_id = "${aws_s3_bucket.lms_bucket_app.id}"
min_ttl = 0
default_ttl = 86400
max_ttl = 31536000

forwarded_values {
query_string = false
cookies {
forward = "none"
}
}
#edge lambda function association
lambda_function_association {
event_type   = "origin-response"
lambda_arn   = "${aws_lambda_function.edge_lambda.qualified_arn}"
include_body = false
}
}

aliases = ["${var.cdn_alias["lms_portal_ui"]}"]
#aliases = []

restrictions {
geo_restriction {
restriction_type = "none"
}
}

viewer_certificate {
cloudfront_default_certificate  = false
   acm_certificate_arn         = "${var.ssl_cert_arn["cdn"]}"
   minimum_protocol_version      = "TLSv1" 
   ssl_support_method        = "sni-only"
}
}



#OUTPUTS
output "lms_launch_ui_cloudfront_id" {
value = "${aws_cloudfront_distribution.www_distribution_lms.id}"
}

output "lms_launch_ui_cdn_url" {
value = "${aws_cloudfront_distribution.www_distribution_lms.domain_name}"
}

output "lms_launch_ui_cdn_alias" {
value = "${aws_cloudfront_distribution.www_distribution_lms.aliases[0]}"
}





#Create Parameter Store
resource "aws_ssm_parameter" "lms_launch_ui_cloudfront_id" {
  name  = "/${var.environment_tag}/${var.product_tag}/lms_launch_ui_cloudfront_id"
  type  = "String"
  value = "${aws_cloudfront_distribution.www_distribution_lms.id}"
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
resource "aws_ssm_parameter" "lms_launch_ui_cdn_alias" {
  name  = "/${var.environment_tag}/${var.product_tag}/lms_launch_ui_cdn_alias"
  type  = "String"
  value = "${aws_cloudfront_distribution.www_distribution_lms.aliases[0]}"
  overwrite = "true"
  tags = {
    Environment = "${var.environment_tag}"
	"Product Name" = "${var.product_tag}"
	"Project Code" = "${var.project_tag}"
	"Project Manager" = "${var.other_tags["Proj_mgr"]}"
	"Project Code" = "${var.project_tag}"
  }
}