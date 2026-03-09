variable "aws_account_id" {
  description = "The AWS Account ID for the deployment"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "alert_email" {
  description = "Email address for SNS notification"
  type        = string
}

variable "iam_role" {
  description = "Primary deploy IAM role"
  type        = string
}

variable "alb_log_reader_arns" {
  description = "Role ARNs that can read ALB logs"
  type        = list(string)
  default     = []
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "branch" {
  description = "Branch running the job"
  type        = string
  default     = "main"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs for EKS"
  type        = list(string)
}

variable "container_name" {
  description = "Application container name reference"
  type        = string
}

variable "container_image" {
  description = "Application container image reference"
  type        = string
}

variable "container_port" {
  description = "Application container port"
  type        = number
}

variable "cpu" {
  description = "Application CPU reference value"
  type        = number
}

variable "memory" {
  description = "Application memory reference value"
  type        = number
}

variable "desired_count" {
  description = "Desired node count for EKS managed node group"
  type        = number
}

variable "max_capacity" {
  description = "Maximum node count for EKS managed node group"
  type        = number
}

variable "min_capacity" {
  description = "Minimum node count for EKS managed node group"
  type        = number
}

variable "enable_efs" {
  description = "Enable EFS resources"
  type        = bool
  default     = false
}

variable "efs_mount_point" {
  description = "Reserved application mount point reference"
  type        = string
  default     = "/mnt/efs"
}

variable "efs_container_path" {
  description = "Reserved application EFS path reference"
  type        = string
  default     = "efs-storage"
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener"
  type        = string
  default     = null
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.29"
}

variable "node_instance_types" {
  description = "EKS managed node group instance types"
  type        = list(string)
  default     = ["m5.large"]
}

variable "container_environment_variables" {
  description = "Optional application environment variables reference"
  type        = any
  default     = []
}

variable "container_secrets" {
  description = "Optional application secrets reference"
  type        = any
  default     = []
}

variable "alb_ingress_rules" {
  description = "List of ingress rules for the ALB"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "alb_egress_rules" {
  description = "List of egress rules for the ALB"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "eks_node_egress_rules" {
  description = "List of egress rules for the EKS node security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "alb_access_log_audit_bucket" {
  description = "Bucket where ALB log bucket access logs are stored"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
