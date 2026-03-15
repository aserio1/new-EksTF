resource "aws_sns_topic" "eks_alb_log_sns_topic" {
  count             = var.create_sns_topic ? 1 : 0
  provider          = aws.eks-role
  name              = "eks_alb_log_notifications_${var.project_name}"
  kms_master_key_id = "alias/aws/sns"
}

locals {
  eks_alb_sns_topic_arn = var.create_sns_topic ? aws_sns_topic.eks_alb_log_sns_topic[0].arn : var.existing_sns_topic_arn
}

resource "aws_sns_topic_policy" "eks_alb_log_sns_policy" {
  count = local.eks_alb_sns_topic_arn != null ? 1 : 0
  arn   = local.eks_alb_sns_topic_arn

  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "Alb_Log_SNS_Notifications_Policy_ID"
    Statement = [
      {
        Effect = "Allow"
        Action = ["SNS:Publish"]
        Resource = local.eks_alb_sns_topic_arn
        Principal = {
          AWS = "*"
        }
        Condition = {
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.eks_alb_access_log.arn
          }
          StringEquals = {
            "aws:SourceAccount" = var.aws_account_id
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "alb_access_log_notification" {
  count    = local.eks_alb_sns_topic_arn != null ? 1 : 0
  provider = aws.eks-role
  bucket   = aws_s3_bucket.eks_alb_access_log.id

  topic {
    topic_arn = local.eks_alb_sns_topic_arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_sns_topic_policy.eks_alb_log_sns_policy
  ]
}

resource "aws_sns_topic_subscription" "alb_access_log_subscription" {
  count     = local.eks_alb_sns_topic_arn != null ? 1 : 0
  provider  = aws.eks-role
  topic_arn = local.eks_alb_sns_topic_arn
  protocol  = "email"
  endpoint  = var.alert_email
}
