# Selenium Grid Deployment with Terraform, Ansible, and GitHub Actions

This project automates the deployment and teardown of a Selenium Grid on AWS EC2 using Terraform, Ansible, and GitHub Actions. It provisions infrastructure, installs Docker, and launches Selenium Hub and Chrome Node containers — all with one-click GitHub workflow dispatches.

## Features

- **Infrastructure as Code**: Managed using Terraform and remote state stored in S3 with DynamoDB locking

- **Configuration Management**: Docker and Selenium setup automated via Ansible

- **CI/CD Automation**: GitHub Actions deploy and destroy infrastructure on demand

- **Secure Key Injection**: SSH keys passed through GitHub secrets

## Workflow Files

### `deploy.yml`
- Provisions EC2 instance with Terraform
- Installs Docker and runs Selenium containers using Ansible
- Injects SSH keys from GitHub Secrets
- Performs cleanup of sensitive files after use

### `destroy.yml`
- Destroys all Terraform-managed resources using the same remote state

## Ansible Playbook

### `playbook.yml`
- Installs Docker
- Starts the Docker service
- Runs Selenium Hub and Chrome Node as containers
- Ensures containers restart on reboot

## Requirements
- AWS credentials with limited access to:
  - Specific S3 bucket for state file
  - Specific DynamoDB table for state locking
  - EC2, VPC, and related resources

- GitHub Secrets:
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - SSH_PUBLIC_KEY
  - SSH_PRIVATE_KEY

## Setup Instructions
1. Clone the repository
2. Create an S3 bucket and DynamoDB table for Terraform backend
3. Add required GitHub secrets
4. Update the Terraform backend configuration with your S3 and DynamoDB resource details
5. Use the GitHub Actions tab to trigger "Deploy Selenium Grid" or "Destroy Selenium Grid"

## Security Notes
- SSH private keys are injected securely and removed after use
- Terraform state is stored remotely with encryption and locking enabled