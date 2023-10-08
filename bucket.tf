
// create buckets
resource "aws_s3_bucket" "images_bucket" {
  count         = length(var.s3_bucket_name)
  bucket        = var.s3_bucket_name[count.index]
  force_destroy = "true"

  tags = {
    Name = (var.s3_bucket_name[count.index])
  }
}

// creating folders in buckets
resource "aws_s3_object" "images_folder" {
  for_each = (data.aws_s3_bucket.get_bucket)
  bucket   = each.key
  key      = "images/"

}