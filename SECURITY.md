# Security Policy

## Reporting Security Vulnerabilities

At Aikido Security, we take security seriously. If you discover a security vulnerability in this Terraform module, please report it responsibly.

**Please do NOT report security vulnerabilities through public GitHub issues.**

### How to Report

Please report security vulnerabilities by emailing: **security@aikido.dev**

Include the following information:

- Description of the vulnerability
- Steps to reproduce the issue
- Potential impact
- Any suggested fixes (if available)

### What to Expect

- We will acknowledge receipt of your vulnerability report within 48 hours
- We will provide a more detailed response within 5 business days
- We will work with you to understand and validate the issue
- Once validated, we will work on a fix and coordinate disclosure timing

## Supported Versions

We provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |
| < 1.0   | :x:                |

## Security Best Practices

When using this module:

1. **Protect your External ID**: Never commit your Aikido external ID to version control
2. **Use variable files**: Store sensitive values in `terraform.tfvars` and add it to `.gitignore`
3. **Review IAM policies**: Understand what permissions are being granted
4. **Monitor CloudTrail**: Track role assumption events in AWS CloudTrail
5. **Rotate External IDs**: Periodically rotate your external ID through the Aikido dashboard
6. **Use least privilege**: Only enable features (ECR, EBS scanning) that you need

## Known Security Considerations

This module creates IAM roles that allow Aikido Security (AWS Account: 881830977366) to access your AWS accounts:

- **CSPM Role**: Read-only access to AWS resources for security auditing
- **ECR Scanning Role**: Read access to ECR repositories (when enabled)
- **EBS Scanning Role**: Ability to create snapshots and read EBS volumes (when enabled)

All role assumptions require:
- Valid External ID (shared secret between you and Aikido)
- AWS STS AssumeRole permissions
- Proper trust relationship configuration

## Third-Party Dependencies

This module has minimal dependencies:
- AWS Provider for Terraform
- AWS Organizations (required for StackSet deployment)

Ensure you keep your Terraform and AWS provider versions up to date for security patches.

## Additional Resources

- [Aikido Security Documentation](https://help.aikido.dev/)
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [Terraform Security Best Practices](https://developer.hashicorp.com/terraform/tutorials/configuration-language/sensitive-variables)
