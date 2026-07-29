module "aikido_security" {
  # Use "github.com/AikidoSec/aws-native-terraform-module//source?ref=v2.0.0" instead
  source = "../source"

  # External ID provided by Aikido Security
  # You can obtain this from your Aikido dashboard when setting up AWS integration
  external_id = var.external_id

  # Organizational unit IDs - use your organization root or specific OUs
  # To find your root: aws organizations list-roots
  # To find OUs: aws organizations list-organizational-units-for-parent --parent-id r-xxxx
  organizational_unit_ids = var.organizational_unit_ids

  # Optional: Exclude specific AWS accounts from Aikido integration
  excluded_account_ids = var.excluded_account_ids

  # Enable ECR container image scanning
  enable_ecr_scanning = true

  # Enable EBS volume scanning
  enable_ebs_scanning = true

  # Optional: Attach additional policies to restrict or extend role permissions.
  # Example: limit ECR scanning to specific regions (see https://help.aikido.dev/cloud-scanning/connect-your-cloud/aws/connect-aws-account-to-aikido/control-which-aws-regions-are-scanned)
  # ecr_additional_policy_arns = [aws_iam_policy.ecr_region_restriction.arn]
  # cspm_additional_policy_arns = []
  # ebs_additional_policy_arns  = []
}
