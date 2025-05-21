# Selenium Grid Deployment with Terraform, Ansible, and GitHub Actions

This project automates the deployment and teardown of a Selenium Grid on AWS EC2 using Terraform, Ansible, and GitHub Actions. It provisions infrastructure, installs Docker and Kind, sets up a single-node Kubernetes cluster, and deploys Selenium Hub, Chrome Node, and a BDD service as Kubernetes deployments — all with one-click GitHub workflow dispatches.

## Features

- **Infrastructure as Code**: Managed using Terraform and remote state stored in S3 with DynamoDB locking

- **Configuration Management**: Kubernetes cluster setup and application deployment automated via Ansible

- **CI/CD Automation**: GitHub Actions deploy and destroy infrastructure on demand

- **Secure Key Injection**: SSH keys passed through GitHub secrets

## Workflow Files

### `deploy.yml`
- Provisions EC2 instance with Terraform
- Installs Docker, Kind, and uses Ansible to set up a Kubernetes cluster and deploy applications.
- Injects SSH keys from GitHub Secrets
- Performs cleanup of sensitive files after use

### `destroy.yml`
- Destroys all Terraform-managed resources using the same remote state

## Ansible Playbook

### `playbook.yml`
- Installs Docker (as a prerequisite for Kind).
- Installs `kubectl` (Kubernetes CLI) and `kind` (Kubernetes in Docker).
- Creates a single-node Kind Kubernetes cluster named 'selenium-grid'.
- Copies Kubernetes manifest files (Deployments and Services) to the instance.
- Applies the Kubernetes manifests to deploy Selenium Hub, Selenium Chrome Node, and the BDD service to the Kind cluster.
- Services are exposed using Kubernetes NodePorts. The EC2 instance's security group is configured to allow access to these NodePorts (typically in the 30000-32767 range).

## Accessing Services
To access the Selenium Hub or the BDD service, use the public IP address of the EC2 instance and the specific NodePort assigned by Kubernetes to that service.

You can find the NodePorts by running the following command on the EC2 instance after the deployment is complete:
```bash
kubectl get services -n default
```
Look for the port mappings for `selenium-hub` and `bdd-service` in the `PORT(S)` column (e.g., `4444:NODE_PORT/TCP` for Selenium Hub and `5000:NODE_PORT/TCP` for the BDD Service). The EC2 instance's security group is configured by Terraform to allow access to the NodePort range (30000-32767).

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