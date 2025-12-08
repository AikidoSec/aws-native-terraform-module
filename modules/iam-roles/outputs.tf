output "cspm_role_arn" {
  description = "ARN of the Aikido CSPM role"
  value       = aws_iam_role.aikido_security_cspm.arn
}

output "cspm_role_name" {
  description = "Name of the Aikido CSPM role"
  value       = aws_iam_role.aikido_security_cspm.name
}

output "ecr_role_arn" {
  description = "ARN of the Aikido ECR scanning role (if enabled)"
  value       = var.enable_ecr_scanning ? aws_iam_role.aikido_security_ecr_scan[0].arn : null
}

output "ecr_role_name" {
  description = "Name of the Aikido ECR scanning role (if enabled)"
  value       = var.enable_ecr_scanning ? aws_iam_role.aikido_security_ecr_scan[0].name : null
}

output "ebs_role_arn" {
  description = "ARN of the Aikido EBS scanning role (if enabled)"
  value       = var.enable_ebs_scanning ? aws_iam_role.aikido_security_ebs_scan[0].arn : null
}

output "ebs_role_name" {
  description = "Name of the Aikido EBS scanning role (if enabled)"
  value       = var.enable_ebs_scanning ? aws_iam_role.aikido_security_ebs_scan[0].name : null
}
