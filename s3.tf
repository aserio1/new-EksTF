resource "aws_s3_bucket" "alb_access_log" {
  bucket        = local.alb_log_bucket_name
  force_destroy = true

  tags = merge(
    {
      Name        = local.alb_log_bucket_name
      Description = "ALB access log bucket"
    },
    var.tags
  )
}

resource "aws_s3_bucket_logging" "alb_access_log_audit" {
  bucket        = aws_s3_bucket.alb_access_log.id
  target_bucket = var.alb_access_log_audit_bucket
  target_prefix = "alb-access-log-audit/${var.project_name}/"
}

resource "aws_s3_bucket_policy" "allow_s3_logging" {
  bucket = var.alb_access_log_audit_bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3Logging"
        Effect = "Allow"
        Principal = {
          Service = "logging.s3.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "arn:aws-us-gov:s3:::${var.alb_access_log_audit_bucket}/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.aws_account_id
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_access_log_encryption" {
  bucket = aws_s3_bucket.alb_access_log.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.iac_kms_key.arn
      sse_algorithm     = "aws:kms"
    }

    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "alb_access_log_block" {
  bucket                  = aws_s3_bucket.alb_access_log.id
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_policy" "alb_access_log" {
  bucket = aws_s3_bucket.alb_access_log.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "default"
    Statement = concat(
      [
        {
          Sid    = "AllowALBLogging"
          Effect = "Allow"
          Principal = {
            Service = "logdelivery.elasticloadbalancing.amazonaws.com"
          }
          Action = [
            "s3:PutObject"
          ]
          Resource = "${aws_s3_bucket.alb_access_log.arn}/AWSLogs/${var.aws_account_id}/*"
          Condition = {
            StringEquals = {
              "s3:x-amz-acl" = "bucket-owner-full-control"
            }
          }
        }
      ],
      [
        for arn in var.alb_log_reader_arns : {
          Sid    = "AllowRead${replace(replace(arn, ":", ""), "/", "")}"
          Effect = "Allow"
          Principal = {
            AWS = arn
          }
          Action = [
            "s3:GetObject",
            "s3:ListBucket"
          ]
          Resource = [
            aws_s3_bucket.alb_access_log.arn,
            "${aws_s3_bucket.alb_access_log.arn}/*"
          ]
        }
      ]
    )
  })
}

resource "aws_s3_bucket_versioning" "alb_access_log_versioning" {
  bucket = aws_s3_bucket.alb_access_log.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "alb_access_log_lifecycle" {
  bucket = aws_s3_bucket.alb_access_log.id

  rule {
    id     = "expire"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 90
    }
  }
}
