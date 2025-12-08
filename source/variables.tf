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
  description = "Enable comprehensive CSPM permissions for full security coverage. When disabled, minimal permissions are used."
  type        = bool
  default     = false
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
