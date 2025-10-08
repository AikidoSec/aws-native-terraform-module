# Complete Example

This example demonstrates a full deployment of the Aikido Security integration with all features enabled.

## Features Enabled

- CSPM (Cloud Security Posture Management)
- ECR (Elastic Container Registry) scanning
- EBS (Elastic Block Store) scanning

## Prerequisites

1. AWS Organizations enabled in your management account
2. AWS CLI configured with appropriate credentials
3. Aikido Security account with an External ID

## Usage

1. **Get your External ID from Aikido Security**

   Log into your Aikido dashboard and navigate to the AWS integration setup to obtain your External ID.

2. **Find your Organization structure**

   ```bash
   # Get your organization root ID
   aws organizations list-roots

   # List OUs (if you want to deploy to specific OUs instead of root)
   aws organizations list-organizational-units-for-parent --parent-id r-xxxx
   ```

3. **Configure variables**

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

4. **Deploy**

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

5. **Configure Aikido**

   After deployment, use the output ARNs to complete the integration in the Aikido dashboard:

   ```bash
   terraform output
   ```

## What Gets Created

### Management Account

- IAM Role: `AikidoSecurityReadonlyRole` (CSPM)
- IAM Role: `AikidoSecurityEcrScanningRole` (ECR scanning)
- IAM Role: `AikidoSecurityEbsScanningRole` (EBS scanning)
- IAM Policies for each role
- CloudFormation StackSet for member accounts

### Member Accounts (via StackSet)

The same roles and policies are automatically deployed to all member accounts in the specified organizational units, excluding any accounts in the `excluded_account_ids` list.

## Cleanup

To remove the Aikido integration:

```bash
terraform destroy
```

Note: You may need to manually delete stack instances from the StackSet if they don't delete automatically.
