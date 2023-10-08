// Bucket-A s3 object upload trigger
resource "aws_s3_bucket_notification" "s3-trigger-lambda" {
  bucket = aws_s3_bucket.images_bucket[0].id
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_remove_exif.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [resource.aws_s3_bucket.images_bucket[0], resource.aws_lambda_function.lambda_remove_exif, resource.aws_lambda_permission.s3_lambda_permissions]
}