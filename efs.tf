resource "aws_efs_file_system" "this" {
  provider         = aws.eks-role
  count            = var.enable_efs ? 1 : 0
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true
  kms_key_id       = aws_kms_key.iac_kms_key.arn

  tags = merge(
    {
      Name        = "${var.project_name}-efs"
      Description = "Application EFS"
    },
    var.tags
  )
}

resource "aws_efs_mount_target" "this" {
  provider        = aws.eks-role
  count           = var.enable_efs ? length(var.private_subnets) : 0
  file_system_id  = aws_efs_file_system.this[0].id
  subnet_id       = var.private_subnets[count.index]
  security_groups = [aws_security_group.efs[0].id]
}

resource "aws_efs_access_point" "this" {
  provider       = aws.eks-role
  count          = var.enable_efs ? 1 : 0
  file_system_id = aws_efs_file_system.this[0].id

  posix_user {
    gid = 1000
    uid = 1000
  }

  root_directory {
    path = "/export"

    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "755"
    }
  }

  tags = merge(
    {
      Name        = "${var.project_name}-efs-access-point"
      Description = "EFS access point"
    },
    var.tags
  )
}
