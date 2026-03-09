resource "aws_sns_topic" "alb_log_sns_topic" {
  provider          = aws.eks-role
  name              = "alb_log_notifications_${var.project_name}-sdo"
  kms_master_key_id = "alias/aws/sns"

  tags = merge(
    {
      Name        = "${var.project_name}-alb-log-notifications"
      Description = "ALB log bucket SNS topic"
    },
    var.tags
  )
}

resource "aws_sns_topic_policy" "alb_log_sns_policy" {
  arn = aws_sns_topic.alb_log_sns_topic.arn

  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "Alb_Log_SNS_Notifications_Policy_ID"
    Statement = [
      {
        Effect = "Allow"
        Action = ["SNS:Publish"]
        Resource = aws_sns_topic.alb_log_sns_topic.arn
        Principal = {
          AWS = "*"
        }
        Condition = {
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.alb_access_log.arn
          }
          StringEquals = {
            "aws:SourceAccount" = var.aws_account_id
          }
        }
      },
      {
        Sid    = "AllowTeamManagement"
        Effect = "Allow"
        Principal = {
          AWS = concat(
            [var.iam_role],
            ["arn:aws-us-gov:iam::263408170269:root"]
          )
        }
        Action = [
          "SNS:Publish",
          "SNS:RemovePermission",
          "SNS:SetTopicAttributes",
          "SNS:DeleteTopic",
          "SNS:ListSubscriptionsByTopic",
          "SNS:GetTopicAttributes",
          "SNS:Receive",
          "SNS:AddPermission",
          "SNS:Subscribe"
        ]
        Resource = aws_sns_topic.alb_log_sns_topic.arn
        Condition = {
          StringEquals = {
            "AWS:SourceOwner" = var.aws_account_id
          }
        }
      },
      {
        Sid    = "AllowTeamReadSubscribe"
        Effect = "Allow"
        Principal = {
          AWS = concat(
            [var.iam_role],
            ["arn:aws-us-gov:iam::263408170269:root"]
          )
        }
        Action = [
          "SNS:Subscribe",
          "SNS:GetTopicAttributes",
          "SNS:Receive"
        ]
        Resource = aws_sns_topic.alb_log_sns_topic.arn
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "alb_access_log_notification" {
  provider = aws.eks-role
  bucket   = aws_s3_bucket.alb_access_log.id

  topic {
    topic_arn = aws_sns_topic.alb_log_sns_topic.arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_sns_topic.alb_log_sns_topic,
    aws_sns_topic_policy.alb_log_sns_policy
  ]
}

resource "aws_sns_topic_subscription" "alb_access_log_subscription" {
  provider  = aws.eks-role
  topic_arn = aws_sns_topic.alb_log_sns_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
