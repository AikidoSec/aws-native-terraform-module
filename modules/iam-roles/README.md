# Aikido Security IAM Roles Module

This submodule creates the necessary IAM roles and policies for Aikido Security integration in a single AWS account, without requiring AWS Organizations or CloudFormation StackSets.

## Use Case

Use this module when you:
- Want to connect a single AWS account to Aikido
- Cannot or don't want to use AWS Organizations StackSets
- Need more control over which accounts get Aikido integration
- Are managing member accounts individually

## Features

This module creates:
- **CSPM Role**: `AikidoSecurityReadonlyRole` with SecurityAudit and custom policies for Cloud Security Posture Management
- **ECR Scanning Role** (optional): `AikidoSecurityEcrScanningRole` for container image scanning
- **EBS Scanning Role** (optional): `AikidoSecurityEbsScanningRole` for volume scanning

## Usage

### Basic Usage (CSPM only)

```hcl
module "aikido_iam" {
  source = "git::https://github.com/AikidoSec/aws-native-terraform-module.git//modules/iam-roles?ref=main"

  external_id = "your-external-id-from-aikido"
}
```

### With ECR and EBS Scanning

```hcl
module "aikido_iam" {
  source = "git::https://github.com/AikidoSec/aws-native-terraform-module.git//modules/iam-roles?ref=main"

  external_id          = "your-external-id-from-aikido"
  enable_ecr_scanning  = true
  enable_ebs_scanning  = true
}
```

### Using a Local Copy

If you've cloned the repository:

```hcl
module "aikido_iam" {
  source = "../../modules/iam-roles"

  external_id          = "your-external-id-from-aikido"
  enable_ecr_scanning  = true
  enable_ebs_scanning  = true
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| external_id | External ID for Aikido Security role assumption | `string` | n/a | yes |
| enable_ecr_scanning | Enable ECR scanning | `bool` | `false` | no |
| enable_ebs_scanning | Enable EBS scanning | `bool` | `false` | no |
| aikido_cspm_scanner_role_arn | ARN of the Aikido cloud scanner role | `string` | `"arn:aws:iam::881830977366:role/service-role/lambda-aws-cloud-findings-role-uox26vzd"` | no |
| aikido_ecr_scanner_role_arn | ARN of the Aikido ECR scanner role | `string` | `"arn:aws:iam::881830977366:role/service-role/lambda-container-image-scanner-role-pb0qotst"` | no |
| aikido_ebs_scanner_role_arn | ARN of the Aikido EBS scanner role | `string` | `"arn:aws:iam::881830977366:role/aws-ebs-scanner-role"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cspm_role_arn | ARN of the Aikido CSPM role |
| cspm_role_name | Name of the Aikido CSPM role |
| ecr_role_arn | ARN of the Aikido ECR scanning role (if enabled) |
| ecr_role_name | Name of the Aikido ECR scanning role (if enabled) |
| ebs_role_arn | ARN of the Aikido EBS scanning role (if enabled) |
| ebs_role_name | Name of the Aikido EBS scanning role (if enabled) |

## Getting Your External ID

1. Log in to your Aikido Security dashboard
2. Navigate to the AWS integration settings
3. Copy the External ID provided by Aikido

## Example: Deploy to Multiple Accounts Individually

You can use this module in separate Terraform configurations for each account:

**Account 1 (Production):**
```hcl
provider "aws" {
  region = "us-east-1"
  alias  = "production"
}

module "aikido_production" {
  source = "git::https://github.com/AikidoSec/aws-native-terraform-module.git//modules/iam-roles?ref=main"

  providers = {
    aws = aws.production
  }

  external_id          = "your-external-id-from-aikido"
  enable_ecr_scanning  = true
  enable_ebs_scanning  = true
}

output "production_cspm_role_arn" {
  value = module.aikido_production.cspm_role_arn
}
```

**Account 2 (Staging):**
```hcl
provider "aws" {
  region = "us-east-1"
  alias  = "staging"
}

module "aikido_staging" {
  source = "git::https://github.com/AikidoSec/aws-native-terraform-module.git//modules/iam-roles?ref=main"

  providers = {
    aws = aws.staging
  }

  external_id          = "your-external-id-from-aikido"
  enable_ecr_scanning  = false
  enable_ebs_scanning  = false
}

output "staging_cspm_role_arn" {
  value = module.aikido_staging.cspm_role_arn
}
```

## Comparison with Root Module

| Feature | Root Module | IAM Roles Submodule |
|---------|-------------|---------------------|
| AWS Organizations | Required | Not required |
| CloudFormation StackSets | Yes | No |
| Management Account | Deploys to | Can deploy to any account |
| Member Accounts | Automatic via StackSets | Manual per account |
| Use Case | Organization-wide deployment | Individual account setup |

## Resources Created

### CSPM (Always created)
- `aws_iam_policy.aikido_security_audit`
- `aws_iam_role.aikido_security_cspm`
- `aws_iam_role_policy_attachment.aikido_security_audit_aws`
- `aws_iam_role_policy_attachment.aikido_security_audit_custom`

### ECR Scanning (if `enable_ecr_scanning = true`)
- `aws_iam_policy.aikido_security_ecr_scan`
- `aws_iam_role.aikido_security_ecr_scan`
- `aws_iam_role_policy_attachment.aikido_security_ecr_scan`

### EBS Scanning (if `enable_ebs_scanning = true`)
- `aws_iam_policy.aikido_security_ebs_scan`
- `aws_iam_role.aikido_security_ebs_scan`
- `aws_iam_role_policy_attachment.aikido_security_ebs_scan`

## License

See the main module's LICENSE file.
