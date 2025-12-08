# Aikido Security AWS Integration Terraform Module

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.0-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-%3E%3D5.0-FF9900?logo=amazon-aws)](https://registry.terraform.io/providers/hashicorp/aws/latest)

This Terraform module sets up [Aikido Security](https://www.aikido.dev/) integration for AWS Organizations. It creates the necessary IAM roles and policies to enable Aikido's Cloud Security Posture Management (CSPM), ECR scanning, and EBS scanning capabilities across your AWS organization.

## Features

- **CSPM (Cloud Security Posture Management)**: Creates a read-only IAM role for Aikido to audit your AWS resources
- **ECR Scanning** (Optional): Enables container image scanning in Amazon Elastic Container Registry
- **EBS Scanning** (Optional): Enables scanning of EBS volumes and snapshots
- **AWS Organizations Support**: Automatically deploys to member accounts using CloudFormation StackSets

## Prerequisites

- AWS Organizations must be enabled in your AWS account
- You must have the necessary permissions to create IAM roles, policies, and CloudFormation StackSets
- An Aikido Security account with an External ID (obtain from Aikido Security)

## Module Variants

This repository provides two ways to integrate Aikido with AWS:

### 1. Organization-Wide Integration (Root Module)
Use the root module (`source/`) for AWS Organizations with automatic deployment to member accounts via StackSets.

**When to use:**
- You have AWS Organizations enabled
- You want automatic deployment to all member accounts
- You can use CloudFormation StackSets

### 2. Single Account Integration (IAM Roles Submodule)
Use the `modules/iam-roles` submodule for individual AWS accounts without Organizations or StackSets.

**When to use:**
- You don't have AWS Organizations
- You cannot use CloudFormation StackSets
- You want to control deployment to specific accounts manually
- You're integrating with a single AWS account

See the [IAM Roles Module Documentation](modules/iam-roles/README.md) for details on using the submodule.

## Usage

```hcl
module "aikido_security" {
  source = "github.com/AikidoSec/aws-native-terraform-module//source?ref=v2.0.0"

  external_id               = "your-aikido-external-id"
  organizational_unit_ids   = ["r-abcd"]  # Your organization root or specific OUs
  excluded_account_ids      = []          # Optional: AWS accounts to exclude
  enable_ecr_scanning       = true
  enable_ebs_scanning       = true
}
```

## Installation

See the [Deployment Guide](DEPLOYMENT.md) for detailed installation instructions and distribution methods.

**Quick Start:**

```hcl
module "aikido_security" {
  source = "github.com/AikidoSec/aws-native-terraform-module//source?ref=v2.0.0"

  external_id             = "your-aikido-external-id"
  organizational_unit_ids = ["r-xxxx"]
  excluded_account_ids    = []
  enable_ecr_scanning     = true
  enable_ebs_scanning     = true
}
```

## Examples

See the [examples](./examples/) directory for complete usage examples.

## Variables

| Name                             | Description                                                                                                                                                  | Type           | Default | Required |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------- | ------- | -------- |
| external_id                      | External ID for Aikido Security role assumption (obtain from Aikido)                                                                                         | `string`       | n/a     | yes      |
| organizational_unit_ids          | The root ID (e.g., r-abcd) or specific OUs (e.g., ou-abcd-1234)                                                                                              | `list(string)` | n/a     | yes      |
| excluded_account_ids             | AWS accounts that will not be connected to Aikido                                                                                                            | `list(string)` | n/a     | yes      |
| enable_comprehensive_permissions | Enable comprehensive CSPM permissions for full security coverage. When disabled, basic permissions are used but Aikido will still attempt additional API calls, resulting in access denied entries in CloudTrail logs. | `bool`         | `false` | no       |
| enable_ecr_scanning              | Enable ECR container scanning                                                                                                                                | `bool`         | `false` | no       |
| enable_ebs_scanning              | Enable EBS volume scanning                                                                                                                                   | `bool`         | `false` | no       |
| cspm_role_name                   | Name of the CSPM IAM role                                                                                                                                    | `string`       | `"AikidoSecurityReadonlyRole"` | no       |
| ecr_role_name                    | Name of the ECR scanning IAM role                                                                                                                            | `string`       | `"AikidoSecurityEcrScanningRole"` | no       |
| ebs_role_name                    | Name of the EBS scanning IAM role                                                                                                                            | `string`       | `"AikidoSecurityEbsScanningRole"` | no       |

## Outputs

| Name          | Description                                      |
| ------------- | ------------------------------------------------ |
| cspm_role_arn | ARN of the Aikido CSPM role                      |
| ecr_role_arn  | ARN of the Aikido ECR scanning role (if enabled) |
| ebs_role_arn  | ARN of the Aikido EBS scanning role (if enabled) |

## Upgrading from v1.0.0 to v2.0.0

⚠️ **Important**: Version 2.0.0 includes internal refactoring that requires state migration. The migration is automated using `moved` blocks.

**Quick upgrade steps:**
1. Update your module source to `ref=v2.0.0`
2. Run `terraform init -upgrade`
3. Run `terraform plan` (you'll see resources being moved)
4. Run `terraform apply`

See the [Migration Guide](MIGRATION.md) for detailed instructions and troubleshooting.

## Resources Created

### Management Account Resources

- **IAM Role**: `AikidoSecurityReadonlyRole` - CSPM read-only role
- **IAM Policy**: `AikidoSecurityAuditPolicy` - Additional audit permissions
- **IAM Role**: `AikidoSecurityEcrScanningRole` - ECR scanning role (if enabled)
- **IAM Policy**: `AikidoSecurityEcrScanPolicy` - ECR scanning permissions (if enabled)
- **IAM Role**: `AikidoSecurityEbsScanningRole` - EBS scanning role (if enabled)
- **IAM Policy**: `AikidoSecurityEbsScanPolicy` - EBS scanning permissions (if enabled)
- **CloudFormation StackSet**: Automatically deploys to member accounts

### Member Account Resources

Member accounts receive the same IAM roles and policies via CloudFormation StackSet, configured with SERVICE_MANAGED permissions and auto-deployment enabled.

## Security Considerations

This module creates cross-account IAM roles that allow Aikido Security (AWS Account: 881830977366) to assume roles in your account with:

- Read-only access for security auditing
- ECR read permissions (if enabled)
- EBS snapshot creation and reading (if enabled)

All role assumptions require the External ID you provide, adding an additional layer of security.

## Setup Instructions

1. **Get your External ID from Aikido Security**

   - Log in to your Aikido Security account
   - Navigate to the AWS integration setup
   - Copy your External ID

2. **Identify your Organization structure**

   - Find your Organization Root ID or specific OU IDs
   - Run: `aws organizations list-roots` and `aws organizations list-organizational-units-for-parent`

3. **Deploy the module**

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Configure Aikido Security**
   - Provide the output role ARNs to Aikido Security
   - Complete the integration in the Aikido dashboard

## Contributing

Contributions are welcome! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

## Security

For security concerns, please see our [Security Policy](SECURITY.md).

## License

This module is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For issues with:

- This Terraform module: Open an issue in this repository
- Aikido Security integration: Contact [Aikido Support](https://www.aikido.dev/contact)
