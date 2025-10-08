# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release of Aikido Security AWS Integration Terraform Module
- CSPM (Cloud Security Posture Management) role and policy
- Optional ECR scanning role and policy
- Optional EBS scanning role and policy
- AWS Organizations support via CloudFormation StackSets
- Auto-deployment to member accounts
- Organizational Unit targeting
- Account exclusion capability

### Documentation
- Comprehensive README with usage examples
- Contributing guidelines
- Release process documentation
- Security policy
- MIT License

### CI/CD
- Terraform validation workflow
- Automated release workflow

## [1.0.0] - YYYY-MM-DD

### Added
- Initial public release

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
