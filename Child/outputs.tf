output "application_url" {
  description = "URL to access the deployed application"
  value       = var.certificate_arn != null ? "https://${module.eks_primary.alb_dns_name}" : "http://${module.eks_primary.alb_dns_name}"
}

output "eks_cluster_identity" {
  description = "EKS Cluster Name"
  value       = module.eks_primary.cluster_name
}

output "storage_details" {
  description = "S3 and EFS details"
  value = {
    s3_bucket = module.eks_primary.s3_bucket_name
    efs_id    = module.eks_primary.efs_id
  }
}

output "kms_key" {
  description = "KMS key ARN"
  value       = module.eks_primary.kms_key_arn
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks_primary.cluster_endpoint
}

output "node_group_name" {
  description = "EKS managed node group name"
  value       = module.eks_primary.node_group_name
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.eks_primary.alb_dns_name
}
