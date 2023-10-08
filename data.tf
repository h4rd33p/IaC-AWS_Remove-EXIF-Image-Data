// to get the account-id in use
data "aws_caller_identity" "current" {
} 

// get buckets for creating folders
data "aws_s3_bucket" "get_bucket" {
  for_each = toset(var.s3_bucket_name)
  bucket = each.value
  depends_on = [aws_s3_bucket.images_bucket]
}

//create archive of python lambda function
data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_dir  = "${path.cwd}/lambda_distribution_package/"
  output_path = var.output_path
  depends_on  = [null_resource.install_python_dependencies]
}

// decrypt password per user
data "pgp_decrypt" "user_password_decrypt" {
  for_each = local.users

  ciphertext          = aws_iam_user_login_profile.generate_user_password[each.key].encrypted_password
  ciphertext_encoding = "base64"
  private_key         = pgp_key.user_login_key[each.key].private_key
}
