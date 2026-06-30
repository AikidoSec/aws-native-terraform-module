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
| <a name="input_aikido_region"></a> [aikido\_region](#input\_aikido\_region) | Aikido instance region. Controls the scanner role ARNs and the CloudFormation StackSet template used for member accounts. Valid values: `"eu"` (default, app.aikido.dev), `"us"` (app.us.aikido.dev), `"me"` (app.me.aikido.dev), `"au"` (app.au.aikido.dev). | `string` | `"eu"` | no |
| <a name="input_cspm_audit_actions"></a> [cspm\_audit\_actions](#input\_cspm\_audit\_actions) | IAM actions to allow in the Aikido Security Audit Policy | `set(string)` | <pre>[<br>  "backup:GetBackupPlan",<br>  "backup:ListBackupPlans",<br>  "backup:ListProtectedResources",<br>  "batch:DescribeJobQueues",<br>  "budgets:ViewBudget",<br>  "ec2:GetEbsEncryptionByDefault",<br>  "ec2:GetLaunchTemplateData",<br>  "ec2:GetSnapshotBlockPublicAccessState",<br>  "eks:DescribeAddon",<br>  "eks:DescribeAddonConfiguration",<br>  "eks:DescribeIdentityProviderConfig",<br>  "eks:DescribeNodegroup",<br>  "eks:DescribePodIdentityAssociation",<br>  "lambda:GetFunction",<br>  "lambda:GetFunctionUrlConfig",<br>  "lambda:GetLayerVersion",<br>  "scheduler:GetSchedule",<br>  "scheduler:ListSchedules",<br>  "states:ListTagsForResource",<br>  "wafv2:GetRuleGroup"<br>]</pre> | no |
| <a name="input_cspm_role_name"></a> [cspm\_role\_name](#input\_cspm\_role\_name) | Name of the CSPM IAM role | `string` | `"AikidoSecurityReadonlyRole"` | no |
| <a name="input_ebs_scan_actions"></a> [ebs\_scan\_actions](#input\_ebs\_scan\_actions) | IAM actions to allow in the primary Aikido Security EBS Scan Policy statement | `set(string)` | <pre>[<br>  "ec2:DescribeInstances",<br>  "ec2:DescribeVolumes",<br>  "ec2:DescribeVolumeStatus",<br>  "ec2:DescribeSnapshots",<br>  "ec2:CreateSnapshot",<br>  "ec2:CreateTags",<br>  "ebs:ListSnapshotBlocks",<br>  "ebs:GetSnapshotBlock",<br>  "kms:DescribeKey",<br>  "kms:Decrypt",<br>  "kms:GenerateDataKey"<br>]</pre> | no |
| <a name="input_ebs_role_name"></a> [ebs\_role\_name](#input\_ebs\_role\_name) | Name of the EBS scanning IAM role | `string` | `"AikidoSecurityEbsScanningRole"` | no |
| <a name="input_ebs_snapshot_cleanup_actions"></a> [ebs\_snapshot\_cleanup\_actions](#input\_ebs\_snapshot\_cleanup\_actions) | IAM actions to allow in the conditioned Aikido Security EBS snapshot cleanup statement | `set(string)` | <pre>[<br>  "ec2:DeleteSnapshot"<br>]</pre> | no |
| <a name="input_ecr_scan_actions"></a> [ecr\_scan\_actions](#input\_ecr\_scan\_actions) | IAM actions to allow in the Aikido Security ECR Scan Policy | `set(string)` | <pre>[<br>  "ecr:BatchCheckLayerAvailability",<br>  "ecr:BatchGetImage",<br>  "ecr:DescribeImages",<br>  "ecr:DescribeRegistry",<br>  "ecr:DescribeRepositories",<br>  "ecr:GetAuthorizationToken",<br>  "ecr:GetDownloadUrlForLayer",<br>  "ecr:ListImages",<br>  "ecr:ListTagsForResource"<br>]</pre> | no |
| <a name="input_ecr_role_name"></a> [ecr\_role\_name](#input\_ecr\_role\_name) | Name of the ECR scanning IAM role | `string` | `"AikidoSecurityEcrScanningRole"` | no |
| <a name="input_enable_comprehensive_permissions"></a> [enable\_comprehensive\_permissions](#input\_enable\_comprehensive\_permissions) | Deprecated: this variable has no effect. Comprehensive permissions are now always enabled. | `bool` | `true` | no |
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
