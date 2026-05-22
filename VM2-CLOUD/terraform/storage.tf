resource "aws_s3_bucket" "muestra_bucket" {
  bucket = var.muestra_bucket_rstate
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "muestra_bucket_versionning" {
  bucket = aws_s3_bucket.muestra_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "muestra_bucket_sse" {
  bucket = aws_s3_bucket.muestra_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "muestra_bucket_pa" {
  bucket                  = aws_s3_bucket.muestra_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}