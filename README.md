# M-A Parent EKS Module

Reusable AWS GovCloud EKS parent module.

## Features

- EKS cluster
- EKS managed node group
- EKS add-ons:
  - coredns
  - kube-proxy
  - vpc-cni
- ALB with HTTP/HTTPS listeners
- ALB target group scaffold
- S3 bucket for ALB access logs
- S3 bucket logging to audit bucket
- KMS encryption
- CloudWatch log group for EKS control plane logs
- SNS notifications for ALB log bucket
- Optional EFS and EFS access point
- Security groups
- EKS access entries for deploy and admin roles

## GovCloud notes

- Uses GovCloud ARN partition: `arn:aws-us-gov`
- Designed for `us-gov-west-1`
- Child/root module passes `aws.eks-role` alias into this module

## Required role inputs

- cluster_role_arn
- node_role_arn
- admin_role_arn
- iam_role

## Example usage

```hcl
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
  alert_email                 = var.alert_email
  alb_access_log_audit_bucket = var.alb_access_log_audit_bucket
  container_port              = var.container_port
  desired_count               = var.desired_count
  max_capacity                = var.max_capacity
  min_capacity                = var.min_capacity
  enable_efs                  = var.enable_efs
  certificate_arn             = var.certificate_arn

  tags                        = var.tags
}
