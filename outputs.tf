output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "node_group_name" {
  description = "Primary node group name"
  value       = aws_eks_node_group.primary.node_group_name
}

output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.this.dns_name
}

output "alb_target_group_arn" {
  description = "ALB target group ARN"
  value       = aws_lb_target_group.this.arn
}

output "s3_bucket_name" {
  description = "ALB access log bucket name"
  value       = aws_s3_bucket.alb_access_log.bucket
}

output "efs_id" {
  description = "EFS file system ID"
  value       = try(aws_efs_file_system.this[0].id, null)
}

output "efs_access_point_id" {
  description = "EFS access point ID"
  value       = try(aws_efs_access_point.this[0].id, null)
}

output "kms_key_arn" {
  description = "KMS key ARN"
  value       = aws_kms_key.iac_kms_key.arn
}

output "alb_sns_topic_arn" {
  description = "SNS topic ARN for ALB log notifications"
  value       = aws_sns_topic.alb_log_sns_topic.arn
}
