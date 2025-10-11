# Contributing to Aikido Security AWS Integration Module

Thank you for your interest in contributing! This document provides guidelines for contributing to this Terraform module.

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected behavior** vs actual behavior
- **Terraform version** and AWS provider version
- **Module version** you're using
- **Relevant code snippets** or configuration

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Clear title and description**
- **Use case** for the enhancement
- **Examples** of how it would work
- **Potential impact** on existing functionality

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following our coding standards
3. **Add tests** if applicable
4. **Update documentation** including README.md if needed
5. **Ensure CI passes** - all validation checks must pass
6. **Write clear commit messages**
7. **Submit a pull request**

## Development Process

### Setting Up Your Development Environment

```bash
# Clone your fork
git clone https://github.com/your-username/aws-native-terraform-module.git
cd aws-native-terraform-module

# Install development dependencies
brew install terraform tflint pre-commit

# Set up pre-commit hooks
pre-commit install
```

### Code Style

- Follow [Terraform style conventions](https://www.terraform.io/docs/language/syntax/style.html)
- Run `terraform fmt -recursive` before committing
- Use meaningful variable and resource names
- Add comments for complex logic

### Testing Your Changes

```bash
# Format code
terraform fmt -recursive

# Validate module
terraform init -backend=false
terraform validate

# Lint code
tflint --recursive

# Test example
cd examples/complete
terraform init -backend=false
terraform validate
```

### Pre-commit Hooks

We use pre-commit hooks to ensure code quality:

```bash
# Install hooks
pre-commit install

# Run manually
pre-commit run --all-files
```

### Documentation

- Update [Readme.md](Readme.md) for any user-facing changes
- Add inline comments for complex Terraform code
- Update examples if adding new features
- Variables and outputs should have clear descriptions

## Commit Message Guidelines

Follow conventional commits format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**

```
feat(ecr): add support for ECR private registries

fix(iam): correct policy permissions for EBS scanning

docs: update README with new variables
```

## Versioning

This project follows [Semantic Versioning](https://semver.org/):

- **MAJOR**: Incompatible API changes
- **MINOR**: Backwards-compatible functionality additions
- **PATCH**: Backwards-compatible bug fixes

## Release Process

Maintainers will handle releases:

1. Update CHANGELOG.md
2. Create and push a version tag
3. GitHub Actions automatically creates the release

## Questions?

Feel free to open an issue with the `question` label if you need help or clarification.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
