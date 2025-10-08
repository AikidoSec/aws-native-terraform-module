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
