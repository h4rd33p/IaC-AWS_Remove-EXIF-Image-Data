# IaC-AWS_Remove-EXIF-Image-Data

Remove EXIF data from the images uploaded to an S3 bucket and then stores the processed images to the destination S3 bucket. 

## Description
Based on the document/guide [here](https://eulink.smartrecruiters.com/c/eJx80EGL3CAYxvFPozeD-mrUg4fQSdqB7RbK3Afz-roTmCSDcRf225eFOba9_x94-OG-PtL2ec7R0gzB2558cBSMpKJtnqHwHI30yXKKqg89WCWt57Sm5f5jOdpev8a9VWjAaq8N5dmlGWdUmp7d5fNB8fv4Ov4eXq7jz-H8cr38un4bXk_n03AZ-S0WQsqWCiJ6Q4iyZJud8QaMyomIL1FLDUpKUD048B3M1vVUDAKU4oJkRh5rqq0S1velUT063Fd-j7fWHgeDgemJ6Qm7v1RMT0cVTwqRWkt4W2lrh3jUPYuMlunpXz5MT3M2waeiRXHaCjNDEsH1SUA2NEurtdLEYKoMTgcIehdIW6vpLhRf6TjSG51zlCpb0qiETcEIkzIIj0aJ4Dw41UPwRfG9Lm_LNm4fS923r4ux1LTxGm9dqszI-_JB3bLx9h_uPwEAAP__Ga2ZHA).

Step 1:
- Images with EXIF data are uploaded to the S3 bucket A(ge-images-bucket-a).
- Any object uploaded to the S3 bucket A(ge-images-bucket-a), triggers S3 notification that runs Python based AWS Lambda function(lambda-exif).
- AWS Lambda function(lambda-exif) checks if the images are of '.jpg' format, removes the EXIF image data and uploads the final image without EXIF data to the destination bucket B(ge-images-bucket-b)

Step 2:
- There are two users UserA and UserB.
- They are added to two different groups "s3_bucketA_readwrite", "s3_bucketB_read".
- UserA's group("s3_bucketA_readwrite") has IAM policy attched with read+write access to bucket A(ge-images-bucket-a)
- UserB's group("s3_bucketB_read") has IAM policy attched with read access only to bucket B(ge-images-bucket-B)
#### Note: The project uses terraform published module [ekristen/pgp](https://registry.terraform.io/providers/ekristen/pgp/latest) to create the public keys per user, that are used to encrypt the passwords per user.

## Prerequisite
- Terraform [installed](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)  
- Access to AWS [account](https://aws.amazon.com/resources/create-account/) and [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) for terraform to connect to the AWS

## Run Locally

Clone the project

```bash
  git clone https://github.com/h4rd33p/IaC-AWS_Remove-EXIF-Image-Data.git
```
Go to the project directory

```bash
  cd IaC-AWS_Remove-EXIF-Image-Data
```
Run terraform to deploy resources in the AWS

```bash
  terraform init
```
```bash
  terraform plan
```
```bash
  terraform apply
```
Clean-up

```bash
  terraform destroy
```
## Future Improvements
- Use of SQS queue to batch requests
