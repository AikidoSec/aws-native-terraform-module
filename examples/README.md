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
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
README.md updated successfully
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->


## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_excluded_account_ids"></a> [excluded\_account\_ids](#input\_excluded\_account\_ids) | List of AWS account IDs to exclude from Aikido integration | `list(string)` | `[]` | no |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | External ID provided by Aikido Security for role assumption | `string` | n/a | yes |
| <a name="input_organizational_unit_ids"></a> [organizational\_unit\_ids](#input\_organizational\_unit\_ids) | List of organization root or OU IDs to deploy to | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cspm_role_arn"></a> [cspm\_role\_arn](#output\_cspm\_role\_arn) | ARN of the Aikido CSPM role - provide this to Aikido |
| <a name="output_ebs_role_arn"></a> [ebs\_role\_arn](#output\_ebs\_role\_arn) | ARN of the Aikido EBS scanning role - provide this to Aikido |
| <a name="output_ecr_role_arn"></a> [ecr\_role\_arn](#output\_ecr\_role\_arn) | ARN of the Aikido ECR scanning role - provide this to Aikido |
<!-- END_TF_DOCS -->
