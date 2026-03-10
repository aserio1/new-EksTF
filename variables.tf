############################################
# CORE AWS SETTINGS
############################################

variable "aws_account_id" {
  description = "AWS account ID used for resource policies and logging"
  type        = string
}

variable "aws_region" {
  description = "AWS GovCloud region"
  type        = string
}

variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}

############################################
# NETWORK SETTINGS
############################################

variable "vpc_id" {
  description = "VPC ID where EKS and ALB resources will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs used by EKS nodes and EFS"
  type        = list(string)
}

############################################
# ALB SECURITY GROUP RULES
############################################

variable "alb_ingress_rules" {
  description = "List of ingress rules for the ALB security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "alb_egress_rules" {
  description = "List of egress rules for the ALB security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

############################################
# EKS WORKER NODE SECURITY GROUP RULES
############################################

variable "eks_node_egress_rules" {
  description = "List of egress rules for the EKS worker node security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

############################################
# EKS CLUSTER SETTINGS
############################################

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "desired_count" {
  description = "Desired number of nodes in the managed node group"
  type        = number
}

variable "min_capacity" {
  description = "Minimum number of nodes in the managed node group"
  type        = number
}

variable "max_capacity" {
  description = "Maximum number of nodes in the managed node group"
  type        = number
}

variable "node_instance_types" {
  description = "Instance types used for the EKS managed node group"
  type        = list(string)
  default     = ["m5.large"]
}

variable "container_port" {
  description = "Application container port used by ALB target group"
  type        = number
}

############################################
# IAM ROLES
############################################

variable "cluster_role_arn" {
  description = "IAM role ARN for the EKS cluster"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for the EKS worker nodes"
  type        = string
}

variable "admin_role_arn" {
  description = "IAM role ARN granted administrative access to the EKS cluster"
  type        = string
}

variable "iam_role" {
  description = "Primary deployment role used for Terraform operations"
  type        = string
}

############################################
# EKS ENDPOINT ACCESS
############################################

variable "endpoint_private_access" {
  description = "Whether the EKS API server endpoint is private"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Whether the EKS API server endpoint is public"
  type        = bool
  default     = false
}

############################################
# CLOUDWATCH LOGGING
############################################

variable "enabled_log_types" {
  description = "List of EKS control plane logs to enable"
  type        = list(string)

  default = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}

variable "cloudwatch_log_retention_days" {
  description = "Retention period for CloudWatch logs"
  type        = number
  default     = 30
}

############################################
# ALB TLS SETTINGS
############################################

variable "certificate_arn" {
  description = "ACM certificate ARN used for HTTPS listener"
  type        = string
  default     = null
}

############################################
# EFS SETTINGS
############################################

variable "enable_efs" {
  description = "Enable EFS filesystem for persistent storage"
  type        = bool
  default     = false
}

variable "efs_mount_point" {
  description = "Application mount path for EFS"
  type        = string
  default     = "/mnt/efs"
}

variable "efs_container_path" {
  description = "Subdirectory created within EFS"
  type        = string
  default     = "efs-storage"
}

############################################
# S3 LOGGING
############################################

variable "alb_access_log_audit_bucket" {
  description = "S3 bucket where ALB access log bucket audit logs are delivered"
  type        = string
}

variable "alb_log_reader_arns" {
  description = "IAM principals allowed to read ALB access logs"
  type        = list(string)
  default     = []
}

############################################
# SNS ALERTING
############################################

variable "alert_email" {
  description = "Email address subscribed to SNS alerts for ALB log events"
  type        = string
}
