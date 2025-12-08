# Example: Using the IAM Roles Submodule
# This example shows how to use the IAM roles submodule for a single AWS account

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "aikido_iam" {
  source = "../"

  # Required: Get this from your Aikido dashboard
  external_id = var.external_id

  # Optional: Enable additional scanning capabilities
  enable_ecr_scanning = var.enable_ecr_scanning
  enable_ebs_scanning = var.enable_ebs_scanning
}

# Outputs to verify the created resources
output "cspm_role_arn" {
  description = "ARN of the Aikido CSPM role"
  value       = module.aikido_iam.cspm_role_arn
}

output "ecr_role_arn" {
  description = "ARN of the Aikido ECR scanning role (if enabled)"
  value       = module.aikido_iam.ecr_role_arn
}

output "ebs_role_arn" {
  description = "ARN of the Aikido EBS scanning role (if enabled)"
  value       = module.aikido_iam.ebs_role_arn
}
