terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    encrypt = true
    bucket  = "iadalfa-tfstate"
    region  = "us-gov-west-1"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      var.tags,
      {
        Name = "${var.project_name}-provider"
      }
    )
  }
}

provider "aws" {
  region = var.aws_region
  alias  = "eks-role"

  assume_role {
    role_arn = "arn:aws-us-gov:iam::262763737219:role/ALFA-Deploy-Role"
  }

  default_tags {
    tags = merge(
      var.tags,
      {
        Name = "${var.project_name}-provider"
      }
    )
  }
}
