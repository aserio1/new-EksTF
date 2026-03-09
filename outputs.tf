output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_security_group_id" {
  value = aws_security_group.eks_cluster.id
}

output "node_security_group_id" {
  value = aws_security_group.eks_nodes.id
}

output "alb_arn" {
  value = aws_lb.internal.arn
}

output "alb_dns_name" {
  value = aws_lb.internal.dns_name
}

output "alb_logs_bucket_name" {
  value = aws_s3_bucket.alb_logs.bucket
}

output "kms_key_arn" {
  value = aws_kms_key.eks.arn
}

output "efs_id" {
  value = try(aws_efs_file_system.this[0].id, null)
}
