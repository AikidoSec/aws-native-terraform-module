# Aikido Security Integration for AWS Organizations

# CSPM Resources
resource "aws_iam_policy" "aikido_security_audit" {
  name        = "AikidoSecurityAuditPolicy"
  description = "Aikido Security Audit Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "backup:ListBackupPlans",
          "backup:GetBackupPlan",
          "backup:ListProtectedResources",
          "budgets:ViewBudget"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "aikido_security_cspm" {
  name = "AikidoSecurityReadonlyRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.aikido_cspm_scanner_role_arn
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.external_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aikido_security_audit_aws" {
  role       = aws_iam_role.aikido_security_cspm.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_iam_role_policy_attachment" "aikido_security_audit_custom" {
  role       = aws_iam_role.aikido_security_cspm.name
  policy_arn = aws_iam_policy.aikido_security_audit.arn
}

# ECR Scanning Resources
resource "aws_iam_policy" "aikido_security_ecr_scan" {
  count       = var.enable_ecr_scanning ? 1 : 0
  name        = "AikidoSecurityEcrScanPolicy"
  description = "Aikido Security ECR Scan Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:DescribeRegistry",
          "ecr:DescribeRepositories",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:ListImages"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "aikido_security_ecr_scan" {
  count = var.enable_ecr_scanning ? 1 : 0
  name  = "AikidoSecurityEcrScanningRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.aikido_ecr_scanner_role_arn
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.external_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aikido_security_ecr_scan" {
  count      = var.enable_ecr_scanning ? 1 : 0
  role       = aws_iam_role.aikido_security_ecr_scan[0].name
  policy_arn = aws_iam_policy.aikido_security_ecr_scan[0].arn
}

# EBS Scanning Resources
resource "aws_iam_policy" "aikido_security_ebs_scan" {
  count       = var.enable_ebs_scanning ? 1 : 0
  name        = "AikidoSecurityEbsScanPolicy"
  description = "Aikido Security EBS Scan Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumeStatus",
          "ec2:DescribeSnapshots",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ebs:ListSnapshotBlocks",
          "ebs:GetSnapshotBlock",
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["ec2:DeleteSnapshot"]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/aikido_snapshot" = "true"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "aikido_security_ebs_scan" {
  count = var.enable_ebs_scanning ? 1 : 0
  name  = "AikidoSecurityEbsScanningRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.aikido_ebs_scanner_role_arn
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.external_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aikido_security_ebs_scan" {
  count      = var.enable_ebs_scanning ? 1 : 0
  role       = aws_iam_role.aikido_security_ebs_scan[0].name
  policy_arn = aws_iam_policy.aikido_security_ebs_scan[0].arn
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

data "aws_region" "current" {}
