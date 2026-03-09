output "cluster_name" {
  value = module.eks_primary.cluster_name
}

output "cluster_arn" {
  value = module.eks_primary.cluster_arn
}

output "cluster_endpoint" {
  value = module.eks_primary.cluster_endpoint
}

output "alb_dns_name" {
  value = module.eks_primary.alb_dns_name
}

output "alb_logs_bucket_name" {
  value = module.eks_primary.alb_logs_bucket_name
}

output "kms_key_arn" {
  value = module.eks_primary.kms_key_arn
}

output "efs_id" {
  value = module.eks_primary.efs_id
}
