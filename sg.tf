# Security Group for the Load Balancer
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow inbound traffic to the ALB"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.alb_ingress_rules
    content {
      description = "Allow rules defined by app owner"
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.alb_egress_rules
    content {
      description = "Allow rules defined by app owner"
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = merge(
    {
      Name        = "${var.project_name}-alb-security-group"
      Description = "ALB Security Group"
    },
    var.tags
  )
}

# Security Group for the EKS Control Plane
resource "aws_security_group" "eks_cluster" {
  name        = "${var.project_name}-eks-cluster-sg"
  description = "Allow traffic for EKS control plane"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name        = "${var.project_name}-eks-cluster-security-group"
      Description = "EKS Cluster Security Group"
    },
    var.tags
  )
}

# Security Group for the EKS Worker Nodes
resource "aws_security_group" "eks_nodes" {
  name        = "${var.project_name}-eks-nodes-sg"
  description = "Allow inbound traffic for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name        = "${var.project_name}-eks-nodes-security-group"
      Description = "EKS Worker Nodes Security Group"
    },
    var.tags
  )
}

# Allow ALB to reach the application port on EKS nodes
resource "aws_security_group_rule" "eks_nodes_from_alb" {
  description              = "Allow application traffic from ALB to EKS nodes"
  type                     = "ingress"
  from_port                = var.container_port
  to_port                  = var.container_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.eks_nodes.id
}

# Allow node-to-node communication inside the EKS node security group
resource "aws_security_group_rule" "eks_nodes_self" {
  description              = "Allow node-to-node communication"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_nodes.id
  security_group_id        = aws_security_group.eks_nodes.id
}

# Allow EKS control plane to communicate with nodes
resource "aws_security_group_rule" "eks_cluster_to_nodes" {
  description              = "Allow EKS control plane communication to worker nodes"
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_cluster.id
  security_group_id        = aws_security_group.eks_nodes.id
}

# Explicit egress rules for EKS worker nodes
resource "aws_security_group_rule" "eks_node_egress" {
  for_each = {
    for idx, rule in var.eks_node_egress_rules :
    idx => rule
  }

  description       = "Allow rules defined by app owner"
  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.eks_nodes.id
}

# Security Group for EFS
resource "aws_security_group" "efs" {
  count       = var.enable_efs ? 1 : 0
  name        = "${var.project_name}-efs-sg"
  description = "Allow inbound traffic for EFS from EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name        = "${var.project_name}-efs-security-group"
      Description = "EFS Security Group"
    },
    var.tags
  )
}

# Allow EKS nodes to talk to EFS on port 2049
resource "aws_security_group_rule" "allow_efs_from_eks_nodes" {
  description              = "Allow NFS traffic from EKS worker nodes to EFS"
  count                    = var.enable_efs ? 1 : 0
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs[0].id
  source_security_group_id = aws_security_group.eks_nodes.id
}

# Allow EFS outbound back to EKS nodes if needed
resource "aws_security_group_rule" "efs_egress_to_eks_nodes" {
  description              = "Allow outbound traffic from EFS security group to EKS worker nodes"
  count                    = var.enable_efs ? 1 : 0
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs[0].id
  source_security_group_id = aws_security_group.eks_nodes.id
}
