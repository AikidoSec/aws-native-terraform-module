# Aikido Security IAM Roles Module
# This module creates IAM roles and policies for Aikido Security integration
# without requiring AWS Organizations or StackSets

# CSPM Resources
resource "aws_iam_policy" "aikido_security_audit" {
  name        = "AikidoSecurityAuditPolicy"
  description = "Aikido Security Audit Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat([
      {
        Effect = "Allow"
        Action = [
          "backup:GetBackupPlan",
          "backup:ListBackupPlans",
          "backup:ListProtectedResources",
          "budgets:ViewBudget"
        ]
        Resource = "*"
      }
      ],
      var.enable_comprehensive_permissions ? [
        {
          Effect = "Allow"
          Action = [
            "batch:DescribeJobQueues",
            "batch:DescribeJobs",
            "batch:ListJobs",
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
            "scheduler:GetSchedule",
            "scheduler:ListSchedules"
          ]
          Resource = "*"
        }
      ] : []
    )
  })
}

resource "aws_iam_role" "aikido_security_cspm" {
  name = var.cspm_role_name

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
  name  = var.ecr_role_name

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
  name  = var.ebs_role_name

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
