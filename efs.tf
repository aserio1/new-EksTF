resource "aws_efs_file_system" "this" {
  count          = var.create_efs ? 1 : 0
  creation_token = "${local.cluster_name}-efs"
  encrypted      = true
  kms_key_id     = aws_kms_key.eks.arn

  tags = merge(local.common_tags, {
    Name = "${local.cluster_name}-efs"
  })
}

resource "aws_security_group" "efs" {
  count       = var.create_efs ? 1 : 0
  name        = "${local.cluster_name}-efs-sg"
  description = "EFS security group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "NFS from EKS nodes"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_efs_mount_target" "this" {
  for_each = var.create_efs ? toset(var.private_subnet_ids) : toset([])

  file_system_id  = aws_efs_file_system.this[0].id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs[0].id]
}
