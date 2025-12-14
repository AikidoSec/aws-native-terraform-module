# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.1] - 2025-12-14

### Fixed

- Fixed IAM policy for EBS scanning to allow `kms:DescribeKey` permission

## [2.0.0] - 2025-12-08

### Added

- New standalone `modules/iam-roles` submodule for deploying Aikido IAM roles to individual AWS accounts without requiring AWS Organizations or CloudFormation StackSets
- Comprehensive documentation for the IAM roles submodule with usage examples
- Example configurations for the IAM roles submodule in `modules/iam-roles/examples/`
- Automated state migration using `moved` blocks for seamless upgrades from v1.0.0
- Migration guide (`MIGRATION.md`) with detailed upgrade instructions
- Support for multi-account deployments without AWS Organizations
- Additional outputs: `cspm_role_name`, `ecr_role_name`, `ebs_role_name`

### Changed

- **BREAKING**: Refactored root module (`source/`) to use the new `modules/iam-roles` submodule internally
  - Terraform state addresses have changed (automated migration provided)
  - No changes to AWS resources, inputs, outputs, or functionality
  - See [MIGRATION.md](MIGRATION.md) for upgrade instructions
- Updated README with "Module Variants" section explaining both deployment options
- Improved modularity and code reusability

### Migration Required

⚠️ **Existing users upgrading from v1.0.0 to v2.0.0**: Your Terraform state will be automatically migrated using `moved` blocks. Simply run `terraform init -upgrade` and `terraform apply`. See [MIGRATION.md](MIGRATION.md) for details.

**New users**: No migration needed. Choose the appropriate module variant for your use case.

## [1.0.0] - 2025-10-11

### Added

- - Initial release of Aikido Security AWS Integration Terraform Module

---

## How to Update This Changelog

When preparing a release, move items from `[Unreleased]` to a new version section with the release date.

### Categories

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security improvements or vulnerability fixes
