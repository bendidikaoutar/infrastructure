resource "aws_s3_bucket" "muestra_uploads" {
  bucket = "muestra-uploads-prod"
  tags   = { Name = "muestra-uploads", Env = "prod" }
}

resource "aws_s3_bucket_public_access_block" "muestra_uploads" {
  bucket                  = aws_s3_bucket.muestra_uploads.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "muestra_uploads" {
  bucket = aws_s3_bucket.muestra_uploads.id
  versioning_configuration {
    status = "Enabled"
  }
}

# IAM user dédié pour le backend
resource "aws_iam_user" "muestra_backend" {
  name = "muestra-backend-s3"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_access_key" "muestra_backend" {
  user = aws_iam_user.muestra_backend.name

  lifecycle {
    prevent_destroy = true
    ignore_changes = all
  }
}

resource "aws_iam_user_policy" "muestra_backend_s3" {
  name = "muestra-backend-s3-policy"
  user = aws_iam_user.muestra_backend.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject", "s3:ListBucket"]
      Resource = [
        aws_s3_bucket.muestra_uploads.arn,
        "${aws_s3_bucket.muestra_uploads.arn}/*"
      ]
    }]
  })
}