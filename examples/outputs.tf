# Outputs from the module
output "cspm_role_arn" {
  description = "ARN of the Aikido CSPM role - provide this to Aikido"
  value       = module.aikido_security.cspm_role_arn
}

output "ecr_scan_role_arn" {
  description = "ARN of the Aikido ECR scanning role - provide this to Aikido"
  value       = module.aikido_security.ecr_scan_role_arn
}

output "ebs_scan_role_arn" {
  description = "ARN of the Aikido EBS scanning role - provide this to Aikido"
  value       = module.aikido_security.ebs_scan_role_arn
}
