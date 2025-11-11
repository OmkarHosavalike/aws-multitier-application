resource "aws_s3_bucket" "app_assets" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = "${var.project}-${var.env}-app-assets"
    Project     = var.project
    Environment = var.env
  }
}

resource "aws_s3_bucket_ownership_controls" "app_assets_owner" {
  bucket = aws_s3_bucket.app_assets.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "app_assets_block" {
  bucket = aws_s3_bucket.app_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "app_assets_versioning" {
  bucket = aws_s3_bucket.app_assets.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_assets_sse" {
  bucket = aws_s3_bucket.app_assets.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}