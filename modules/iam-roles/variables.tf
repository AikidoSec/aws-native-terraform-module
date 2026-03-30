variable "external_id" {
  description = "External ID for Aikido Security role assumption"
  type        = string
}

variable "enable_comprehensive_permissions" {
  description = "Deprecated: this variable has no effect. Comprehensive permissions are now always enabled."
  type        = bool
  default     = true
}

variable "enable_ecr_scanning" {
  description = "Enable ECR scanning"
  type        = bool
  default     = false
}

variable "enable_ebs_scanning" {
  description = "Enable EBS scanning"
  type        = bool
  default     = false
}

variable "aikido_cspm_scanner_role_arn" {
  description = "ARN of the Aikido cloud scanner role"
  type        = string
  default     = "arn:aws:iam::881830977366:role/service-role/lambda-aws-cloud-findings-role-uox26vzd"
}

variable "aikido_ecr_scanner_role_arn" {
  description = "ARN of the Aikido ECR scanner role"
  type        = string
  default     = "arn:aws:iam::881830977366:role/service-role/lambda-container-image-scanner-role-pb0qotst"
}

variable "aikido_ebs_scanner_role_arn" {
  description = "ARN of the Aikido EBS scanner role"
  type        = string
  default     = "arn:aws:iam::881830977366:role/aws-ebs-scanner-role"
}

variable "cspm_role_name" {
  description = "Name of the CSPM IAM role"
  type        = string
  default     = "AikidoSecurityReadonlyRole"
}

variable "cspm_audit_actions" {
  description = "List of IAM actions to allow in the Aikido Security Audit Policy"
  type        = list(string)
  default = [
    "backup:GetBackupPlan",
    "backup:ListBackupPlans",
    "backup:ListProtectedResources",
    "batch:DescribeJobQueues",
    "budgets:ViewBudget",
    "ec2:GetEbsEncryptionByDefault",
    "ec2:GetLaunchTemplateData",
    "ec2:GetSnapshotBlockPublicAccessState",
    "eks:DescribeAddon",
    "eks:DescribeAddonConfiguration",
    "eks:DescribeIdentityProviderConfig",
    "eks:DescribeNodegroup",
    "eks:DescribePodIdentityAssociation",
    "lambda:GetFunction",
    "lambda:GetFunctionUrlConfig",
    "lambda:GetLayerVersion",
    "scheduler:GetSchedule",
    "scheduler:ListSchedules",
    "states:ListTagsForResource",
    "wafv2:GetRuleGroup",
  ]
}

variable "ecr_role_name" {
  description = "Name of the ECR scanning IAM role"
  type        = string
  default     = "AikidoSecurityEcrScanningRole"
}

variable "ebs_role_name" {
  description = "Name of the EBS scanning IAM role"
  type        = string
  default     = "AikidoSecurityEbsScanningRole"
}
