// python lambda function dependecies installation
resource "null_resource" "install_python_dependencies" {
  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/package_lambda_python.sh"

    environment = {
      source_code_path = var.path_source_code
      function_name    = var.function_name
      path_module      = path.module
      runtime          = "python3.10"
      path_cwd         = path.cwd
    }
  }
}

// python lambda function to remove exif data
resource "aws_lambda_function" "lambda_remove_exif" {
  function_name    = var.function_name
  filename         = data.archive_file.python_lambda_package.output_path
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  role             = aws_iam_role.lambda_iam_role.arn
  runtime          = var.runtime
  handler          = "lambda_function.python_lambda_function.lambda_handler"
  depends_on       = [aws_cloudwatch_log_group.lambda_exif_log_group, null_resource.install_python_dependencies]
  timeout          = 10

  environment {
    variables = {
      destination_bucket = ("${var.s3_bucket_name[1]}")
    }
  }
}

// setting permission to invoke python lambda function on object upload to the Bucket-A 
resource "aws_lambda_permission" "s3_lambda_permissions" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_remove_exif.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.images_bucket[0].arn
}

// creating log-group to monitor python lambda function
resource "aws_cloudwatch_log_group" "lambda_exif_log_group" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

