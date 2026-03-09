# R-A - Child Repo for EKS Deployment

This repository calls the reusable parent module `M-A`.

## Purpose

- Keeps environment-specific values in one place
- Calls the parent GitHub module
- Uses GovCloud IAM roles
- Supports Jenkins-driven deploys

## IAM roles used

- EKS Cluster Role  
  `arn:aws-us-gov:ALFA-EKSCLUSTER`

- Deploy Role  
  `arn:aws-us-gov/ALFA-Deploy-Role`

- Node Role  
  `arn:aws-us-gov/ALFA-EKS`

- Admin Role  
  `arn:aws-us-go/IADSDC`

## Deploy

```bash
terraform init -backend-config=eks-primary/backend.hcl
terraform plan -var-file=eks.tfvars
terraform apply -var-file=eks.tfvars
