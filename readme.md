# DevOps-AWS_Remove-EXIF-Image-Data

Removes EXIF data from Images uploaded to a bucket and the stores then processed images in the next bucket 

## Description
Based on the document/guide found [here](https://eulink.smartrecruiters.com/c/eJx80EGL3CAYxvFPozeD-mrUg4fQSdqB7RbK3Afz-roTmCSDcRf225eFOba9_x94-OG-PtL2ec7R0gzB2558cBSMpKJtnqHwHI30yXKKqg89WCWt57Sm5f5jOdpev8a9VWjAaq8N5dmlGWdUmp7d5fNB8fv4Ov4eXq7jz-H8cr38un4bXk_n03AZ-S0WQsqWCiJ6Q4iyZJud8QaMyomIL1FLDUpKUD048B3M1vVUDAKU4oJkRh5rqq0S1velUT063Fd-j7fWHgeDgemJ6Qm7v1RMT0cVTwqRWkt4W2lrh3jUPYuMlunpXz5MT3M2waeiRXHaCjNDEsH1SUA2NEurtdLEYKoMTgcIehdIW6vpLhRf6TjSG51zlCpb0qiETcEIkzIIj0aJ4Dw41UPwRfG9Lm_LNm4fS923r4ux1LTxGm9dqszI-_JB3bLx9h_uPwEAAP__Ga2ZHA).

## Prerequisite
- Terraform [installed](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)  
- Access to AWS [account](https://aws.amazon.com/resources/create-account/) and [configured](https://support.hashicorp.com/hc/en-us/articles/360041289933-Using-AWS-AssumeRole-with-the-AWS-Terraform-Provider) for terraform to connect to the AWS

Step 1:
- Images with EXIF data are uploaded to the S3 bucket A(ge-images-bucket-a).
- Any object uploaded to the S3 bucket A(ge-images-bucket-a) triggers S3 notification that runs Python based AWS Lambda function(lambda-exif).
- AWS Lambda function(lambda-exif) checks if the images are of '.jpg' format, removes the EXIF image data and uploads the final image without EXIF data to the destination bucket B(ge-images-bucket-a)

Step 2:
- There two users created UserA and UserA.
- They are added to two different groups.
- UserA's group have IAM policy attched that gives read+write access to bucket A(ge-images-bucket-a)
- UserB's group have IAM policy attched that gives read access only to bucket B(ge-images-bucket-B)
#### Note: The project uses terrafom published [ekristen/pgp](https://registry.terraform.io/providers/ekristen/pgp/latest) to create the public keys to create encrypted passwords per user. 

## Run Locally

Clone the project

```bash
  git clone https://github.com/h4rd33p/DevOps-AWS_Remove-EXIF-Image-Data.git
```
Go to the project directory

```bash
  cd my-project
```
Run terraform to deploy resources in the AWS

```bash
  terraform init
  terraform plan
  terraform apply
```
Clean-up

```bash
  terraform destroy
```
## Future Improvements
- Use of SQS queue to batch requests