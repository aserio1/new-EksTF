variable "region" {
  description = "AWS GovCloud region"
  type        = string
  default     = "us-gov-west-1"
}

variable "name_prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for worker nodes and EKS"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for ALB/NLB if needed"
  type        = list(string)
  default     = []
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "cluster_role_arn" {
  description = "IAM role ARN for EKS control plane"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for managed node groups"
  type        = string
}

variable "admin_role_arn" {
  description = "Additional admin IAM role ARN for cluster access"
  type        = string
}

variable "deploy_role_arn" {
  description = "Terraform deployment role ARN"
  type        = string
}

variable "node_instance_types" {
  description = "Managed node group instance types"
  type        = list(string)
  default     = ["m5.large"]
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_min_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 5
}

variable "endpoint_private_access" {
  type    = bool
  default = true
}

variable "endpoint_public_access" {
  type    = bool
  default = false
}

variable "enabled_log_types" {
  description = "EKS control plane logs"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cloudwatch_log_retention_days" {
  type    = number
  default = 30
}

variable "alb_log_bucket_force_destroy" {
  type    = bool
  default = false
}

variable "create_efs" {
  type    = bool
  default = true
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
