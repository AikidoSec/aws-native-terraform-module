# Deployment and Distribution Guide

This guide explains how to use and distribute the Aikido Security AWS Integration Terraform Module.

## For Module Users

### Method 1: GitHub Source (Recommended)

This is the recommended approach for most users as it allows version pinning and easy updates.

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

**Note:** The `//source` in the path points to the `source` directory where the Terraform module files are located.

**Advantages:**

- Pin to specific versions using `?ref=v2.0.0`
- Easy to update by changing the version tag
- Direct from source, always authentic
- No manual downloads required

### Method 2: Release Archive

Download a specific release and use it locally or from a URL.

**Download and use locally:**

```bash
# Download the release
curl -LO https://github.com/AikidoSec/aws-native-terraform-module/releases/download/v2.0.0/aikido-aws-terraform-module-2.0.0.zip

# Extract
unzip aikido-aws-terraform-module-2.0.0.zip -d terraform-modules/

# Use in your Terraform configuration
```

```hcl
module "aikido_security" {
  source = "./terraform-modules/aikido-aws-terraform-module-2.0.0/source"

  external_id             = "your-aikido-external-id"
  organizational_unit_ids = ["r-xxxx"]
  excluded_account_ids    = []
  enable_ecr_scanning     = true
  enable_ebs_scanning     = true
}
```

**Direct URL:**

```hcl
module "aikido_security" {
  source = "https://github.com/AikidoSec/aws-native-terraform-module/releases/download/v2.0.0/aikido-aws-terraform-module-2.0.0.zip//source"

  external_id             = "your-aikido-external-id"
  organizational_unit_ids = ["r-xxxx"]
  excluded_account_ids    = []
  enable_ecr_scanning     = true
  enable_ebs_scanning     = true
}
```

**Advantages:**

- Works in air-gapped environments
- Can be hosted on internal systems
- Similar pattern to other security vendors

---

## For Module Maintainers

### Creating a Release

1. **Ensure all changes are merged to main:**

   ```bash
   git checkout main
   git pull origin main
   ```

2. **Update CHANGELOG.md:**

   Move items from `[Unreleased]` to a new version section:

   ```markdown
   ## [1.0.0] - 2025-01-15

   ### Added

   - Initial public release
   - CSPM role and policy
   - Optional ECR scanning
   - Optional EBS scanning
   ```

3. **Create and push a version tag:**

   ```bash
   # For a new version
   git tag -a v1.0.0 -m "Release v1.0.0 - Initial public release"
   git push origin v1.0.0
   ```

4. **GitHub Actions will automatically:**

   - Validate the Terraform code
   - Generate a changelog
   - Create a GitHub release
   - Attach a `.zip` archive of the module
   - Mark pre-releases appropriately (alpha, beta, rc)

5. **Verify the release:**
   - Check the Actions tab for workflow status
   - Review the release in the Releases section
   - Test the release by using it in a Terraform configuration

### Version Numbering

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (v1.0.0 → v2.0.0): Breaking changes

  - Changed variable names
  - Removed outputs
  - Changed resource names (forces recreation)

- **MINOR** (v1.0.0 → v1.1.0): New features, backwards compatible

  - New optional variables
  - New outputs
  - New optional features

- **PATCH** (v1.0.0 → v1.0.1): Bug fixes, backwards compatible
  - Bug fixes
  - Documentation updates
  - Security patches

### Pre-release Versions

For testing before official release:

```bash
# Alpha - early testing
git tag -a v1.1.0-alpha.1 -m "Alpha release for testing"

# Beta - feature complete, testing phase
git tag -a v1.1.0-beta.1 -m "Beta release for user testing"

# Release Candidate - final testing
git tag -a v1.1.0-rc.1 -m "Release candidate"

git push origin v1.1.0-alpha.1
```

Pre-releases are automatically marked in GitHub releases.

---

## Testing Releases

Before announcing a release, test it:

```bash
# Test with GitHub source
cat > test.tf <<EOF
module "aikido_test" {
  source = "github.com/AikidoSec/aws-native-terraform-module//source?ref=v1.0.0"

  external_id             = "test-external-id"
  organizational_unit_ids = ["r-test"]
  excluded_account_ids    = []
}
EOF

terraform init
terraform validate
rm -rf .terraform test.tf
```

```bash
# Test with archive URL
cat > test.tf <<EOF
module "aikido_test" {
  source = "https://github.com/AikidoSec/aws-native-terraform-module/releases/download/v1.0.0/aikido-aws-terraform-module-1.0.0.zip//source"

  external_id             = "test-external-id"
  organizational_unit_ids = ["r-test"]
  excluded_account_ids    = []
}
EOF

terraform init
terraform validate
rm -rf .terraform test.tf
```

---

## Troubleshooting

### Release Workflow Failed

1. Check Actions tab for error details
2. Common issues:
   - Terraform validation failures
   - Missing GitHub token permissions
   - Invalid version tag format

### Module Source Not Found

- Ensure the tag exists: `git tag -l`
- Check GitHub releases page
- Verify URL is correct (case-sensitive)

### Archive Download Issues

- Check GitHub releases page for attached files
- Verify the version number in URL matches release
- Check network/firewall for GitHub access

---

## Best Practices

1. **Always pin to a specific version** in production
2. **Test new versions** in a non-production environment first
3. **Read the CHANGELOG** before upgrading
4. **Keep your Terraform version** up to date
5. **Back up your state** before major version upgrades

---

## Support

- **Module issues:** Open an issue in this repository
- **Aikido platform:** Contact Aikido Support at https://www.aikido.dev/contact
- **Security vulnerabilities:** See [SECURITY.md](SECURITY.md)
