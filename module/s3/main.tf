
# CodePipeline Bucket
resource "aws_s3_bucket" "codepipelinebucket" {
  bucket_prefix = var.codepipeline_bucket_name
}

# CodeBuild Bucket
# resource "aws_s3_bucket" "codebuildbucket" {
#   bucket_prefix = var.codebuild_bucket_name
# }

# Private Bucket to store software

resource "aws_s3_bucket" "software_bucket" {
  bucket_prefix = var.software_bucket_name
  force_destroy = false
}

resource "aws_s3_bucket_versioning" "private_versioning" {
  bucket = aws_s3_bucket.software_bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "private" {
  bucket = aws_s3_bucket.software_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "private_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.private]

  bucket = aws_s3_bucket.software_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.software_bucket.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# Public Bucket to store Images


resource "aws_s3_bucket" "public_bucket" {
  bucket_prefix = var.public_bucket_name
  force_destroy = false
}

resource "aws_s3_bucket_versioning" "public_versioning" {
  bucket = aws_s3_bucket.public_bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "acl" {
  bucket = aws_s3_bucket.public_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.public_bucket.id

  depends_on = [aws_s3_bucket_public_access_block.acl]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.public_bucket.arn}/*"
        Condition = {
          StringLike = {
            "aws:Referer" = ""
          }
        }
      }
    ]
  })
}
