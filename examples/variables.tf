variable "external_id" {
  description = "External ID provided by Aikido Security for role assumption"
  type        = string
  # Obtain this from your Aikido Security dashboard
  # Example: "1234567890abcdef"
}

variable "organizational_unit_ids" {
  description = "List of organization root or OU IDs to deploy to"
  type        = list(string)
  # Example for organization root: ["r-a1b2"]
  # Example for specific OUs: ["ou-a1b2-c3d4e5f6", "ou-a1b2-g7h8i9j0"]
}

variable "excluded_account_ids" {
  description = "List of AWS account IDs to exclude from Aikido integration"
  type        = list(string)
  default     = []
  # Example: ["123456789012", "234567890123"]
}
