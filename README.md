# M-A - Parent Terraform EKS Module

This repository contains a reusable AWS GovCloud EKS parent module.

## Features

- EKS control plane
- Managed node group
- EKS add-ons:
  - CoreDNS
  - kube-proxy
  - VPC CNI
- CloudWatch control plane logs
- KMS encryption for EKS secrets
- S3 bucket for ALB access logs with KMS encryption
- Internal ALB
- Optional EFS
- Security groups
- EKS access entry for admin role

## GovCloud notes

- Uses `arn:aws-us-gov`
- Intended for `us-gov-west-1` or `us-gov-east-1`
- Root/child configuration should assume a GovCloud deploy role

## Usage

This module is intended to be called from a child/root repo such as `R-A`.

Example:

```hcl
module "eks_primary" {
  source = "git::https://github.com/ORG/M-A.git?ref=v1.0.0"

  providers = {
    aws          = aws
    aws.eks-role = aws.eks-role
  }

  name_prefix        = "alfa"
  environment        = "primary"
  region             = "us-gov-west-1"
  vpc_id             = "vpc-xxxx"
  private_subnet_ids = ["subnet-a", "subnet-b", "subnet-c"]

  cluster_role_arn = "arn:ALFA-EKSCLUSTER"
  node_role_arn    = "a/ALFA-EKS"
  admin_role_arn   = "aIADSDC"
  deploy_role_arn  = "Deploy-Role"
}
