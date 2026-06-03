# Aikido Security IAM Roles Module
# This module creates IAM roles and policies for Aikido Security integration
# without requiring AWS Organizations or StackSets

locals {
  scanner_role_arns = {
    eu = {
      cspm = "arn:aws:iam::881830977366:role/service-role/lambda-aws-cloud-findings-role-uox26vzd"
      ecr  = "arn:aws:iam::881830977366:role/service-role/lambda-container-image-scanner-role-pb0qotst"
      ebs  = "arn:aws:iam::881830977366:role/aws-ebs-scanner-role"
    }
    us = {
      cspm = "arn:aws:iam::881830977366:role/lambda-aws-cloud-findings-us-east-1"
      ecr  = "arn:aws:iam::881830977366:role/lambda-container-image-scanner-us-east-1"
      ebs  = "arn:aws:iam::881830977366:role/lambda-aws-ebs-scanner-us-east-1"
    }
    me = {
      cspm = "arn:aws:iam::881830977366:role/lambda-aws-cloud-findings-me-central-1"
      ecr  = "arn:aws:iam::881830977366:role/lambda-container-image-scanner-me-central-1"
      ebs  = "arn:aws:iam::881830977366:role/lambda-aws-ebs-scanner-me-central-1"
    }
    au = {
      cspm = "arn:aws:iam::881830977366:role/lambda-aws-cloud-findings-ap-southeast-2"
      ecr  = "arn:aws:iam::881830977366:role/lambda-container-image-scanner-ap-southeast-2"
      ebs  = "arn:aws:iam::881830977366:role/lambda-aws-ebs-scanner-ap-southeast-2"
    }
  }

  cspm_scanner_role_arn = local.scanner_role_arns[var.aikido_region].cspm
  ecr_scanner_role_arn  = local.scanner_role_arns[var.aikido_region].ecr
  ebs_scanner_role_arn  = local.scanner_role_arns[var.aikido_region].ebs
}

# CSPM Resources
resource "aws_iam_policy" "aikido_security_audit" {
  name        = "AikidoSecurityAuditPolicy"
  description = "Aikido Security Audit Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = var.cspm_audit_actions
        Resource = "*"
      },
      {
        Effect   = "Deny"
        Action   = ["rds:DownloadDBLogFilePortion"]
        Resource = "*"
      }
    ]
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
          AWS = local.cspm_scanner_role_arn
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
          AWS = local.ecr_scanner_role_arn
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
          "kms:DescribeKey",
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
          AWS = local.ebs_scanner_role_arn
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
