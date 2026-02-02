resource "random_id" "bucket_suffix" {
  count = var.bucket_count
  byte_length = 4
}

# !! Quand on fait un bucket on va aussi créer les IAM (access management) qui vont avec
resource "aws_s3_bucket" "this" {
  count = var.bucket_count
  bucket = lower("${var.prefix}-s3-bucket-${count.index + 1}-${random_id.bucket_suffix[count.index].hex}")
  tags = { Name = "${var.prefix}-bucket-${count.index + 1}" }
}

resource "aws_s3_bucket_versioning" "vers" {
  count = var.bucket_count
  bucket = aws_s3_bucket.this[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  count = var.bucket_count
  bucket = aws_s3_bucket.this[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "acls" {
  count = var.bucket_count
  bucket = aws_s3_bucket.this[count.index].id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}