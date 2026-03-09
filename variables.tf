variable "aws_account_id" {
  description = "The AWS account ID"
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

variable "iam_role" {
  description = "Primary deploy/admin IAM role ARN"
  type        = string
}

variable "alb_log_reader_arns" {
  description = "IAM role/user ARNs allowed to read ALB log bucket"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet IDs for ALB"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet IDs for EKS and EFS"
  type        = list(string)
}

variable "alert_email" {
  description = "Email for SNS subscription"
  type        = string
}

variable "alb_access_log_audit_bucket" {
  description = "Existing audit bucket for ALB log bucket access logging"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener"
  type        = string
  default     = null
}

variable "container_port" {
  description = "Application port used by ALB target group and node access"
  type        = number
  default     = 8080
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.29"
}

variable "desired_count" {
  description = "Desired size for EKS managed node group"
  type        = number
  default     = 2
}

variable "min_capacity" {
  description = "Minimum size for EKS managed node group"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum size for EKS managed node group"
  type        = number
  default     = 5
}

variable "node_instance_types" {
  description = "EKS managed node group instance types"
  type        = list(string)
  default     = ["m5.large"]
}

variable "cluster_role_arn" {
  description = "EKS control plane IAM role ARN"
  type        = string
}

variable "node_role_arn" {
  description = "EKS managed node group IAM role ARN"
  type        = string
}

variable "admin_role_arn" {
  description = "Additional EKS admin IAM role ARN"
  type        = string
}

variable "endpoint_private_access" {
  description = "Enable private endpoint access"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public endpoint access"
  type        = bool
  default     = false
}

variable "enable_efs" {
  description = "Enable EFS resources"
  type        = bool
  default     = false
}

variable "efs_mount_point" {
  description = "Reserved for downstream app usage"
  type        = string
  default     = "/mnt/efs"
}

variable "efs_container_path" {
  description = "Reserved for downstream app usage"
  type        = string
  default     = "efs-storage"
}

variable "enabled_log_types" {
  description = "EKS control plane log types"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cloudwatch_log_retention_days" {
  description = "Retention for EKS control plane CloudWatch logs"
  type        = number
  default     = 30
}

variable "alb_ingress_rules" {
  description = "Ingress rules for ALB security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "alb_egress_rules" {
  description = "Egress rules for ALB security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "eks_node_egress_rules" {
  description = "Egress rules for EKS node security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
