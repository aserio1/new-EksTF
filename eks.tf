resource "aws_eks_cluster" "this" {
  name     = local.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.cluster_version

  enabled_cluster_log_types = var.enabled_log_types

  encryption_config {
    provider {
      key_arn = aws_kms_key.iac_kms_key.arn
    }
    resources = ["secrets"]
  }

  vpc_config {
    subnet_ids              = var.private_subnets
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    security_group_ids      = [aws_security_group.eks_cluster.id]
  }

  depends_on = [
    aws_cloudwatch_log_group.eks
  ]

  tags = merge(
    {
      Name        = local.cluster_name
      Description = "EKS cluster"
      Project     = var.project_name
      Application = var.project_name
    },
    var.tags
  )
}

resource "aws_eks_node_group" "primary" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project_name}-primary"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnets
  instance_types  = var.node_instance_types
  capacity_type   = "ON_DEMAND"

  scaling_config {
    desired_size = var.desired_count
    min_size     = var.min_capacity
    max_size     = var.max_capacity
  }

  update_config {
    max_unavailable = 1
  }

  tags = merge(
    {
      Name        = "${var.project_name}-primary-ng"
      Description = "Primary EKS managed node group"
      Project     = var.project_name
      Application = var.project_name
    },
    var.tags
  )

  depends_on = [
    aws_eks_cluster.this
  ]
}
