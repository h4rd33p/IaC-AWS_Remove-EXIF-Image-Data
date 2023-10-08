variable "region" {
  description = "Selected AWS Region"
  default = "eu-west-1"
}

variable "s3_bucket_name" {
  description = "S3 Buckets to create"
  type    = list(string)
  default = ["ge-images-bucket-a", "ge-images-bucket-b"]
}

variable "path_source_code" {
  description = "Python Lambda Function Folder"
  default = "lambda_function"
}

variable "function_name" {
  description = "Python Lambda Function Name"
  default = "lambda-exif"
}
 
variable "output_path" {
  description = "Path to Python Lambda function's deployment package into local filesystem. eg: /path/lambda_function.zip"
  default     = "lambda_exif.zip"
}

variable "lambda_pkg_folder" {
  description = "Folder name to create distribution files"
  default     = "lambda_distribution_package"
}

variable "runtime" {
  description = "Python runtime version"
  default = "python3.10"
}

variable "distribution_pkg_folder" {
  description = "Folder name to create distribution files"
  default     = "lambda_distribution_package"
}


variable "user_groups" {
  description = "Groups to create"
  type    = list(string)
  default = ["s3_bucketA_readwrite", "s3_bucketB_read"]
}

variable "bucket_to_group_mapping" {
  description = "buckets to groups mapping"
  default = {
    "s3_bucketA_readwrite" = "ge-images-bucket-a",
    "s3_bucketB_read" : "ge-images-bucket-b"
  }
}

variable "group_policy_mappings" {
  description = "groups to policies mapping"
  default = {
    "s3_bucketA_readwrite" = ["ge-images-bucket-a-policy"],
    "s3_bucketB_read"      = ["ge-images-bucket-b-policy"]
  }
}

variable "user_group_mappings" {
  description = "users to groups mapping"
  default = {
    "UserA" = ["s3_bucketA_readwrite"],
    "UserB" = ["s3_bucketB_read"]
  }
}

