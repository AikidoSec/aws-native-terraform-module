# Migration Guide: v1.0.0 to v2.0.0

## Overview

Version 2.0.0 introduces a modular architecture by extracting IAM roles into a reusable submodule. While this change is functionally equivalent and maintains the same AWS resources, it requires Terraform state migration for existing deployments.

## What Changed?

### Internal Refactoring
The root module (`source/`) now uses the `modules/iam-roles` submodule internally instead of defining IAM resources directly. This change:
- ✅ **Does NOT change** any AWS resources (same names, policies, permissions)
- ✅ **Does NOT change** module inputs or outputs
- ✅ **Does NOT affect** CloudFormation StackSets behavior
- ⚠️ **DOES change** Terraform state resource addresses

### New Feature
A new standalone submodule (`modules/iam-roles`) is now available for customers who need to integrate individual AWS accounts without AWS Organizations or StackSets.

## Who Needs to Migrate?

**You need to migrate if:**
- You are currently using v1.0.0 (or earlier) of the root module
- You want to upgrade to v2.0.0
- You have existing Terraform state with Aikido resources

**You do NOT need to migrate if:**
- You are deploying Aikido for the first time
- You are using the new `modules/iam-roles` submodule separately

## Migration Options

### Option 1: Automated Migration (Recommended)

Version 2.0.0 includes `moved` blocks that automatically handle state migration. This is the simplest approach.

#### Steps:

1. **Update your module source to v2.0.0:**
   ```hcl
   module "aikido_security" {
     source = "github.com/AikidoSec/aws-native-terraform-module//source?ref=v2.0.0"

     # ... your existing configuration
   }
   ```

2. **Run Terraform init:**
   ```bash
   terraform init -upgrade
   ```

3. **Run Terraform plan:**
   ```bash
   terraform plan
   ```

   You should see output indicating resources are being moved:
   ```
   Terraform will perform the following actions:

     # aws_iam_role.aikido_security_cspm has moved to module.iam_roles.aws_iam_role.aikido_security_cspm
     ...
   ```

4. **Apply the changes:**
   ```bash
   terraform apply
   ```

The `moved` blocks will automatically update your state file without making any changes to AWS resources.

### Option 2: Manual State Migration

If you prefer manual control or encounter issues with automated migration:

#### Steps:

1. **Update your module source to v2.0.0:**
   ```hcl
   module "aikido_security" {
     source = "github.com/AikidoSec/aws-native-terraform-module//source?ref=v2.0.0"

     # ... your existing configuration
   }
   ```

2. **Run Terraform init:**
   ```bash
   terraform init -upgrade
   ```

3. **Move resources in state (adjust based on your configuration):**

   **CSPM Resources (always present):**
   ```bash
   terraform state mv \
     'module.aikido_security.aws_iam_policy.aikido_security_audit' \
     'module.aikido_security.module.iam_roles.aws_iam_policy.aikido_security_audit'

   terraform state mv \
     'module.aikido_security.aws_iam_role.aikido_security_cspm' \
     'module.aikido_security.module.iam_roles.aws_iam_role.aikido_security_cspm'

   terraform state mv \
     'module.aikido_security.aws_iam_role_policy_attachment.aikido_security_audit_aws' \
     'module.aikido_security.module.iam_roles.aws_iam_role_policy_attachment.aikido_security_audit_aws'

   terraform state mv \
     'module.aikido_security.aws_iam_role_policy_attachment.aikido_security_audit_custom' \
     'module.aikido_security.module.iam_roles.aws_iam_role_policy_attachment.aikido_security_audit_custom'
   ```

   **ECR Resources (if `enable_ecr_scanning = true`):**
   ```bash
   terraform state mv \
     'module.aikido_security.aws_iam_policy.aikido_security_ecr_scan[0]' \
     'module.aikido_security.module.iam_roles.aws_iam_policy.aikido_security_ecr_scan[0]'

   terraform state mv \
     'module.aikido_security.aws_iam_role.aikido_security_ecr_scan[0]' \
     'module.aikido_security.module.iam_roles.aws_iam_role.aikido_security_ecr_scan[0]'

   terraform state mv \
     'module.aikido_security.aws_iam_role_policy_attachment.aikido_security_ecr_scan[0]' \
     'module.aikido_security.module.iam_roles.aws_iam_role_policy_attachment.aikido_security_ecr_scan[0]'
   ```

   **EBS Resources (if `enable_ebs_scanning = true`):**
   ```bash
   terraform state mv \
     'module.aikido_security.aws_iam_policy.aikido_security_ebs_scan[0]' \
     'module.aikido_security.module.iam_roles.aws_iam_policy.aikido_security_ebs_scan[0]'

   terraform state mv \
     'module.aikido_security.aws_iam_role.aikido_security_ebs_scan[0]' \
     'module.aikido_security.module.iam_roles.aws_iam_role.aikido_security_ebs_scan[0]'

   terraform state mv \
     'module.aikido_security.aws_iam_role_policy_attachment.aikido_security_ebs_scan[0]' \
     'module.aikido_security.module.iam_roles.aws_iam_role_policy_attachment.aikido_security_ebs_scan[0]'
   ```

4. **Verify with Terraform plan:**
   ```bash
   terraform plan
   ```

   The output should show "No changes" if migration was successful.

### Option 3: Stay on v1.0.0

If you prefer not to migrate, you can continue using v1.0.0:
```hcl
module "aikido_security" {
  source = "github.com/AikidoSec/aws-native-terraform-module//source?ref=v1.0.0"

  # ... your configuration
}
```

Version 1.0.0 will continue to work but won't receive new features.

## Troubleshooting

### Issue: "Resource already exists" errors

**Symptom:** Terraform tries to create resources that already exist in AWS.

**Solution:** This means state migration didn't complete. Use Option 2 (Manual State Migration) to move resources in your state file.

### Issue: "Resource not found in state"

**Symptom:** Terraform can't find resources to move.

**Cause:** Your module might be named differently or resources might already be migrated.

**Solution:**
1. List your current state to find exact resource addresses:
   ```bash
   terraform state list | grep aikido
   ```
2. Adjust the state move commands to match your actual resource names.

### Issue: Moved blocks not working

**Symptom:** Automated migration (Option 1) doesn't move resources.

**Cause:** Older Terraform versions may not support `moved` blocks (requires Terraform 1.0+).

**Solution:**
1. Upgrade Terraform to 1.0 or later
2. Or use Option 2 (Manual State Migration)

## Verification

After migration, verify everything is working:

1. **Check Terraform plan shows no changes:**
   ```bash
   terraform plan
   ```
   Expected output: `No changes. Your infrastructure matches the configuration.`

2. **Verify IAM roles in AWS Console:**
   - `AikidoSecurityReadonlyRole` should exist
   - `AikidoSecurityEcrScanningRole` (if ECR scanning enabled)
   - `AikidoSecurityEbsScanningRole` (if EBS scanning enabled)

3. **Verify outputs:**
   ```bash
   terraform output
   ```
   Should show the same role ARNs as before migration.

## Support

If you encounter issues during migration:
1. Check this guide's Troubleshooting section
2. Review the [CHANGELOG.md](CHANGELOG.md) for detailed changes
3. Open an issue in the [GitHub repository](https://github.com/AikidoSec/aws-native-terraform-module/issues)

## New in v2.0.0

### IAM Roles Submodule

A new standalone submodule is now available for deploying Aikido to individual AWS accounts without AWS Organizations:

```hcl
module "aikido_iam" {
  source = "github.com/AikidoSec/aws-native-terraform-module//modules/iam-roles?ref=v2.0.0"

  external_id         = "your-external-id"
  enable_ecr_scanning = true
  enable_ebs_scanning = true
}
```

See [modules/iam-roles/README.md](modules/iam-roles/README.md) for details.
