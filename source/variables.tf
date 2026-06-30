variable "external_id" {
  description = "External ID for Aikido Security role assumption"
  type        = string
}

variable "organizational_unit_ids" {
  description = "The root ID (e.g., r-abcd) or specific OUs (e.g., ou-abcd-1234, ou-abcd-5678)"
  type        = list(string)
}

variable "excluded_account_ids" {
  description = "The AWS accounts that will not be connected to Aikido"
  type        = list(string)
  default     = []
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

variable "aikido_region" {
  description = "Aikido instance region. Controls the scanner role ARNs and the CloudFormation StackSet template used for member accounts. Valid values: \"eu\" (default, app.aikido.dev), \"us\" (app.us.aikido.dev), \"me\" (app.me.aikido.dev), \"au\" (app.au.aikido.dev)."
  type        = string
  default     = "eu"

  validation {
    condition     = contains(["eu", "us", "me", "au"], var.aikido_region)
    error_message = "aikido_region must be one of: \"eu\", \"us\", \"me\", \"au\"."
  }
}

variable "cspm_role_name" {
  description = "Name of the CSPM IAM role"
  type        = string
  default     = "AikidoSecurityReadonlyRole"
}

variable "cspm_audit_actions" {
  description = "IAM actions to allow in the Aikido Security Audit Policy"
  type        = set(string)
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

variable "ecr_scan_actions" {
  description = "IAM actions to allow in the Aikido Security ECR Scan Policy"
  type        = set(string)
  default = [
    "ecr:BatchCheckLayerAvailability",
    "ecr:BatchGetImage",
    "ecr:DescribeImages",
    "ecr:DescribeRegistry",
    "ecr:DescribeRepositories",
    "ecr:GetAuthorizationToken",
    "ecr:GetDownloadUrlForLayer",
    "ecr:ListImages",
    "ecr:ListTagsForResource",
  ]
}

variable "ecr_role_name" {
  description = "Name of the ECR scanning IAM role"
  type        = string
  default     = "AikidoSecurityEcrScanningRole"
}

variable "ebs_scan_actions" {
  description = "IAM actions to allow in the primary Aikido Security EBS Scan Policy statement"
  type        = set(string)
  default = [
    "ec2:DescribeInstances",
    "ec2:DescribeVolumes",
    "ec2:DescribeVolumeStatus",
    "ec2:DescribeSnapshots",
    "ec2:CreateSnapshot",
    "ec2:CreateTags",
    "ebs:ListSnapshotBlocks",
    "ebs:GetSnapshotBlock",
    "kms:DescribeKey",
    "kms:Decrypt",
    "kms:GenerateDataKey",
  ]
}

variable "ebs_snapshot_cleanup_actions" {
  description = "IAM actions to allow in the conditioned Aikido Security EBS snapshot cleanup statement"
  type        = set(string)
  default = [
    "ec2:DeleteSnapshot",
  ]
}

variable "ebs_role_name" {
  description = "Name of the EBS scanning IAM role"
  type        = string
  default     = "AikidoSecurityEbsScanningRole"
}
