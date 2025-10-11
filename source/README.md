# source

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
README.md updated successfully
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->


## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack_set.member_accounts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set) | resource |
| [aws_cloudformation_stack_set_instance.member_accounts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set_instance) | resource |
| [aws_iam_policy.aikido_security_audit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.aikido_security_ebs_scan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.aikido_security_ecr_scan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.aikido_security_cspm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.aikido_security_ebs_scan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.aikido_security_ecr_scan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aikido_security_audit_aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.aikido_security_audit_custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.aikido_security_ebs_scan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.aikido_security_ecr_scan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aikido_cspm_scanner_role_arn"></a> [aikido\_cspm\_scanner\_role\_arn](#input\_aikido\_cspm\_scanner\_role\_arn) | ARN of the Aikido cloud scanner role | `string` | `"arn:aws:iam::881830977366:role/service-role/lambda-aws-cloud-findings-role-uox26vzd"` | no |
| <a name="input_aikido_ebs_scanner_role_arn"></a> [aikido\_ebs\_scanner\_role\_arn](#input\_aikido\_ebs\_scanner\_role\_arn) | ARN of the Aikido EBS scanner role | `string` | `"arn:aws:iam::881830977366:role/aws-ebs-scanner-role"` | no |
| <a name="input_aikido_ecr_scanner_role_arn"></a> [aikido\_ecr\_scanner\_role\_arn](#input\_aikido\_ecr\_scanner\_role\_arn) | ARN of the Aikido ECR scanner role | `string` | `"arn:aws:iam::881830977366:role/service-role/lambda-container-image-scanner-role-pb0qotst"` | no |
| <a name="input_enable_ebs_scanning"></a> [enable\_ebs\_scanning](#input\_enable\_ebs\_scanning) | Enable EBS scanning | `bool` | `false` | no |
| <a name="input_enable_ecr_scanning"></a> [enable\_ecr\_scanning](#input\_enable\_ecr\_scanning) | Enable ECR scanning | `bool` | `false` | no |
| <a name="input_excluded_account_ids"></a> [excluded\_account\_ids](#input\_excluded\_account\_ids) | The AWS accounts that will not be connected to Aikido | `list(string)` | `[]` | no |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | External ID for Aikido Security role assumption | `string` | n/a | yes |
| <a name="input_organizational_unit_ids"></a> [organizational\_unit\_ids](#input\_organizational\_unit\_ids) | The root ID (e.g., r-abcd) or specific OUs (e.g., ou-abcd-1234, ou-abcd-5678) | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cspm_role_arn"></a> [cspm\_role\_arn](#output\_cspm\_role\_arn) | ARN of the Aikido CSPM role |
| <a name="output_ebs_role_arn"></a> [ebs\_role\_arn](#output\_ebs\_role\_arn) | ARN of the Aikido EBS scanning role (if enabled) |
| <a name="output_ecr_role_arn"></a> [ecr\_role\_arn](#output\_ecr\_role\_arn) | ARN of the Aikido ECR scanning role (if enabled) |
<!-- END_TF_DOCS -->
