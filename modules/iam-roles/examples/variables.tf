variable "external_id" {
  description = "External ID for Aikido Security role assumption (get from Aikido dashboard)"
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
