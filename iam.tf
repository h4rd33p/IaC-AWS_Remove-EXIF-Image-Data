//create execution role for lambda function 
resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda_iam_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

// attach access policy to lambda function's role
resource "aws_iam_role_policy" "lambda_iam_policy" {
  name = "lambda_policy_name"
  role = aws_iam_role.lambda_iam_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::*"
    }    
  ]
}
EOF
}

// empty resource for wait timer
resource "null_resource" "previous" {}

// wait timer
resource "time_sleep" "wait_60_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "60s"
}

// cloudwatch logs permissions managed policy attachment to the the lambda role
// with wait to attach at last
resource "aws_iam_role_policy_attachment" "labmda-role-polcy-attach" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  depends_on = [time_sleep.wait_60_seconds]
}

