module "eks_primary" {
  source = "git::https://github.com/YOUR-ORG/M-A.git?ref=v1.0.0"

  providers = {
    aws          = aws
    aws.eks-role = aws.eks-role
  }

  region             = var.region
  name_prefix        = var.name_prefix
  environment        = var.environment
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  public_subnet_ids  = var.public_subnet_ids
  cluster_version    = var.cluster_version

  cluster_role_arn = "arn:awsALFA-EKSCLUSTER"
  deploy_role_arn  = "arn/ALFA-Deploy-Role"
  node_role_arn    = "arn:/ALFA-EKS"
  admin_role_arn   = "arn:a/IADSDC"

  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size

  tags = merge(
    {
      Owner = "Platform"
      Repo  = "R-A"
    },
    var.tags
  )
}
