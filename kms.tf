resource "aws_kms_key" "iac_kms_key" {
  description             = "${var.project_name} EKS and EFS encryption key"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableRootPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:${data.aws_partition.current.partition}:iam::${var.aws_account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowPlatformRoles"
        Effect = "Allow"
        Principal = {
          AWS = compact([
            var.iam_role,
            var.cluster_role_arn,
            var.node_role_arn,
            var.admin_role_arn
          ])
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey*",
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:ReEncrypt*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(
    {
      Name        = "${var.project_name}-kms"
      Description = "EKS KMS Key"
    },
    var.tags
  )
}

resource "aws_kms_alias" "iac_kms_key" {
  name          = "alias/${var.project_name}-eks"
  target_key_id = aws_kms_key.iac_kms_key.key_id
}
