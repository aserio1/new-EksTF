# M-A Parent EKS Module

Reusable AWS GovCloud Terraform module that provisions a full Amazon EKS platform stack.

This module is designed to be called from environment-specific child repositories.

---

# Features

This module provisions the following infrastructure:

## EKS
- EKS Cluster
- Managed Node Group
- Cluster encryption using KMS
- EKS add-ons
  - CoreDNS
  - kube-proxy
  - VPC CNI

## Networking
- Application Load Balancer (ALB)
- Target Group
- HTTP / HTTPS listeners
- Security Groups
- VPC integration

## Storage
- S3 bucket for ALB access logs
- S3 bucket encryption using KMS
- S3 lifecycle policies
- Optional EFS filesystem
- Optional EFS Access Point

## Observability
- CloudWatch log group for EKS control plane logs
- SNS notifications for ALB access log bucket events

## Security
- KMS encryption for:
  - EKS secrets
  - EFS
  - S3
- Controlled security group rules
- No hard-coded CIDR ranges
- Security rules supplied by child module

---

# Repository Structure
