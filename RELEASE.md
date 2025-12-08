# Release Process

This document describes how to create a new release of the Aikido Security AWS Integration Terraform Module.

## Automated Releases

Releases are automated via GitHub Actions. When you push a version tag, the release workflow will:

1. Validate the Terraform code
2. Generate a changelog
3. Create a GitHub release
4. Make the module downloadable

## Creating a Release

### 1. Prepare the Release

Ensure all changes are merged to `main` and CI passes:

```bash
git checkout main
git pull origin main
```

### 2. Create and Push a Version Tag

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** version: Incompatible API changes
- **MINOR** version: Add functionality (backwards compatible)
- **PATCH** version: Bug fixes (backwards compatible)

```bash
# For a new minor version
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### 3. Monitor the Release

1. Go to the **Actions** tab in GitHub
2. Watch the "Release Module" workflow
3. Once complete, check the **Releases** section

## Pre-release Versions

For alpha, beta, or release candidates:

```bash
git tag -a v1.1.0-beta.1 -m "Beta release v1.1.0-beta.1"
git push origin v1.1.0-beta.1
```

These will be marked as pre-releases automatically.

## Using Released Versions

After release, users can reference specific versions:

```hcl
module "aikido_security" {
  source = "github.com/your-org/aws-native-terraform-module?ref=v2.0.0"

  # ... configuration
}
```

## Troubleshooting

### Release Workflow Failed

1. Check the workflow logs in the Actions tab
2. Ensure Terraform validation passes locally:
   ```bash
   terraform init -backend=false
   terraform validate
   ```
3. Fix issues and create a new tag

### Need to Update a Release

1. Delete the tag locally and remotely:
   ```bash
   git tag -d v1.0.0
   git push origin :refs/tags/v1.0.0
   ```
2. Delete the release in GitHub UI
3. Create the tag again with fixes
