// Current account in use
output "account_id" {
  description = "Selected AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

// ARN for buckets
output "images_bucket_arn" {
  value = aws_s3_bucket.images_bucket.*.arn
}

// ARN for python lambda function 
output "lambda_remove_exif_arn" {
  value = aws_lambda_function.lambda_remove_exif.arn
}

// passwords for users
output "credentials" {
  value = {
    for k, v in local.users : k => {
      "password" = data.pgp_decrypt.user_password_decrypt[k].plaintext
    }
  }
  sensitive = false //set to true if encrypted password required. 
}