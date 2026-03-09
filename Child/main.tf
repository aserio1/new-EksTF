module "eks_primary" {
  source = "git::https://github.ice.dhs.gov/M-A/alfa-modules.git//eks?ref=main"

  providers = {
    aws          = aws
    aws.eks-role = aws.eks-role
  }

  aws_account_id              = var.aws_account_id
  aws_region                  = var.aws_region
  project_name                = var.project_name
  iam_role                    = var.iam_role
  alb_log_reader_arns         = var.alb_log_reader_arns

  vpc_id                      = var.vpc_id
  public_subnets              = var.public_subnets
  private_subnets             = var.private_subnets

  alb_ingress_rules           = var.alb_ingress_rules
  alb_egress_rules            = var.alb_egress_rules
  eks_node_egress_rules       = var.eks_node_egress_rules

  alert_email                 = var.alert_email
  alb_access_log_audit_bucket = var.alb_access_log_audit_bucket

  container_port              = var.container_port

  desired_count               = var.desired_count
  max_capacity                = var.max_capacity
  min_capacity                = var.min_capacity
  cluster_version             = var.cluster_version
  node_instance_types         = var.node_instance_types

  enable_efs                  = var.enable_efs
  efs_mount_point             = var.efs_mount_point
  efs_container_path          = var.efs_container_path
  certificate_arn             = var.certificate_arn

  cluster_role_arn            = "/ALFA-EKSCLUSTER"
  node_role_arn               = e/ALFA-EKS"
  admin_role_arn              = "ae/IADSDC"

  tags                        = var.tags
}
