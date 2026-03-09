terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region

  assume_role {
    role_arn     = "arn:/ALFA-Deploy-Role"
    session_name = "terraform-ra-deploy"
  }

  default_tags {
    tags = {
      Project     = "R-A"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

provider "aws" {
  alias  = "eks-role"
  region = var.region

  assume_role {
    role_arn     = "arn:role/ALFA-EKSCLUSTER"
    session_name = "terraform-ra-eks-role"
  }

  default_tags {
    tags = {
      Project     = "R-A"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
