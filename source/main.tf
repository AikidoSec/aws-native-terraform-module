# Aikido Security Integration for AWS Organizations

# IAM roles for management account
module "iam_roles" {
  source = "../modules/iam-roles"

  external_id                  = var.external_id
  enable_ecr_scanning          = var.enable_ecr_scanning
  enable_ebs_scanning          = var.enable_ebs_scanning
  aikido_cspm_scanner_role_arn = var.aikido_cspm_scanner_role_arn
  aikido_ecr_scanner_role_arn  = var.aikido_ecr_scanner_role_arn
  aikido_ebs_scanner_role_arn  = var.aikido_ebs_scanner_role_arn
}

# State migration blocks for v1.0.0 -> v2.0.0 upgrade
# These automatically move resources from the old flat structure to the new module structure

# CSPM resources
moved {
  from = aws_iam_policy.aikido_security_audit
  to   = module.iam_roles.aws_iam_policy.aikido_security_audit
}

moved {
  from = aws_iam_role.aikido_security_cspm
  to   = module.iam_roles.aws_iam_role.aikido_security_cspm
}

moved {
  from = aws_iam_role_policy_attachment.aikido_security_audit_aws
  to   = module.iam_roles.aws_iam_role_policy_attachment.aikido_security_audit_aws
}

moved {
  from = aws_iam_role_policy_attachment.aikido_security_audit_custom
  to   = module.iam_roles.aws_iam_role_policy_attachment.aikido_security_audit_custom
}

# ECR scanning resources
moved {
  from = aws_iam_policy.aikido_security_ecr_scan
  to   = module.iam_roles.aws_iam_policy.aikido_security_ecr_scan
}

moved {
  from = aws_iam_role.aikido_security_ecr_scan
  to   = module.iam_roles.aws_iam_role.aikido_security_ecr_scan
}

moved {
  from = aws_iam_role_policy_attachment.aikido_security_ecr_scan
  to   = module.iam_roles.aws_iam_role_policy_attachment.aikido_security_ecr_scan
}

# EBS scanning resources
moved {
  from = aws_iam_policy.aikido_security_ebs_scan
  to   = module.iam_roles.aws_iam_policy.aikido_security_ebs_scan
}

moved {
  from = aws_iam_role.aikido_security_ebs_scan
  to   = module.iam_roles.aws_iam_role.aikido_security_ebs_scan
}

moved {
  from = aws_iam_role_policy_attachment.aikido_security_ebs_scan
  to   = module.iam_roles.aws_iam_role_policy_attachment.aikido_security_ebs_scan
}

# Member accounts stack set
# Note: This deploys the same resources to all member accounts in the organization
resource "aws_cloudformation_stack_set" "member_accounts" {
  name             = "aikido-security-cspm-stackset"
  description      = "StackSet for setting up Aikido integration in the member accounts"
  template_url     = "https://aikido-production-staticfiles-public.s3.eu-west-1.amazonaws.com/minimal-policy-member-account.yaml"
  permission_model = "SERVICE_MANAGED"
  capabilities     = ["CAPABILITY_NAMED_IAM"]

  parameters = {
    ExternalId        = var.external_id
    EnableEcrScanning = var.enable_ecr_scanning ? "true" : "false"
    EnableEbsScanning = var.enable_ebs_scanning ? "true" : "false"
  }

  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }

  managed_execution {
    active = true
  }

  operation_preferences {
    failure_tolerance_percentage = 100
    max_concurrent_percentage    = 100
  }
}

# Deploy stack set instances to organizational units
resource "aws_cloudformation_stack_set_instance" "member_accounts" {
  stack_set_name = aws_cloudformation_stack_set.member_accounts.name

  deployment_targets {
    organizational_unit_ids = var.organizational_unit_ids
    account_filter_type     = length(var.excluded_account_ids) > 0 ? "DIFFERENCE" : "NONE"
    accounts_url            = null
    accounts                = length(var.excluded_account_ids) > 0 ? var.excluded_account_ids : null
  }

  operation_preferences {
    failure_tolerance_percentage = 100
    max_concurrent_percentage    = 100
  }

  # Ensure stack set is ready before deploying instances
  depends_on = [aws_cloudformation_stack_set.member_accounts]
}
