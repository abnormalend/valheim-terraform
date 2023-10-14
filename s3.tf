# This is for the S3 bucket and files that we load into it.

resource "aws_s3_bucket" "bucket" {
    bucket_prefix = "valheim-resources"
}

resource "aws_s3_object" "bucket_resources" {
  for_each = fileset("./s3_resources/", "*")

  bucket = aws_s3_bucket.bucket.bucket
  key = "resources/${each.value}"
  source = "./s3_resources/${each.value}"
  etag = filemd5("./s3_resources/${each.value}")
}