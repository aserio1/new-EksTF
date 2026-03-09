resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = var.cloudwatch_log_retention_days
  kms_key_id        = aws_kms_key.iac_kms_key.arn

  tags = merge(
    {
      Name        = "${var.project_name}-eks-logs"
      Description = "EKS control plane logs"
    },
    var.tags
  )
}
