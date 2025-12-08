output "cspm_role_arn" {
  description = "ARN of the Aikido CSPM role"
  value       = module.iam_roles.cspm_role_arn
}

output "ecr_role_arn" {
  description = "ARN of the Aikido ECR scanning role (if enabled)"
  value       = module.iam_roles.ecr_role_arn
}

output "ebs_role_arn" {
  description = "ARN of the Aikido EBS scanning role (if enabled)"
  value       = module.iam_roles.ebs_role_arn
}
