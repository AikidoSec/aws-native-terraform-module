variable "external_id" {
  description = "External ID for Aikido Security role assumption"
  type        = string
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
