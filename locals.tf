locals {
  cluster_name = "${var.name_prefix}-${var.environment}-eks"

  common_tags = merge(
    {
      Name        = local.cluster_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Repository  = "M-A"
    },
    var.tags
  )
}
