resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow inbound traffic to ALB"
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

resource "aws_security_group" "eks_cluster" {
  name        = "${var.project_name}-eks-cluster-sg"
  description = "EKS control plane security group"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name        = "${var.project_name}-eks-cluster-sg"
      Description = "EKS Cluster Security Group"
    },
    var.tags
  )
}

resource "aws_security_group" "eks_nodes" {
  name        = "${var.project_name}-eks-nodes-sg"
  description = "Allow inbound traffic for EKS worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    description = "Node to node"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description              = "Traffic from ALB to application port on worker nodes"
    from_port                = var.container_port
    to_port                  = var.container_port
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.alb.id
  }

  ingress {
    description              = "Cluster to nodes"
    from_port                = 1025
    to_port                  = 65535
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.eks_cluster.id
  }

  tags = merge(
    {
      Name        = "${var.project_name}-eks-nodes-security-group"
      Description = "EKS Worker Node Security Group"
    },
    var.tags
  )
}

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

resource "aws_security_group" "efs" {
  count       = var.enable_efs ? 1 : 0
  name        = "${var.project_name}-efs-sg"
  description = "Allow inbound traffic from EKS nodes to EFS"
  vpc_id      = var.vpc_id

  ingress {
    description              = "Allow NFS from EKS nodes"
    from_port                = 2049
    to_port                  = 2049
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.eks_nodes.id
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name        = "${var.project_name}-efs-security-group"
      Description = "EFS Security Group"
    },
    var.tags
  )
}
