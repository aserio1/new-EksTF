data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  alb_log_bucket_name = "${var.project_name}-alb-access-log-${data.aws_region.current.name}"
  cluster_name        = "${var.project_name}-eks"

  common_tags = merge(
    {
      Name        = local.cluster_name
      Project     = var.project_name
      Application = var.project_name
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}
