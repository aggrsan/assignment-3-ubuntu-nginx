# Terraform EC2 Nginx Ubuntu Deployment

A complete Infrastructure as Code (IaC) project that provisions an AWS EC2 instance running Ubuntu 20.04 LTS with Nginx web server and a custom welcome page using Terraform.

## 📋 Project Overview

This Terraform configuration demonstrates best practices for provisioning cloud infrastructure, including:
- AWS provider configuration with region management
- Data sources for discovering existing AWS resources
- EC2 instance provisioning with user data scripts
- Security group management for HTTP and SSH access
- IAM roles and instance profiles
- SSH key pair generation
- Proper tagging and resource organization

## 🏗️ Resources Created

| Resource | Details | Purpose |
|----------|---------|---------|
| **EC2 Instance** | t2.micro, Ubuntu 20.04 LTS | Web server running Nginx |
| **Security Group** | terraform-nginx-sg | Allows inbound HTTP (80) and SSH (22) |
| **IAM Role** | mern-ec2-role | EC2 instance permissions |
| **Key Pair** | adish-nginx-keypair | SSH access to instance |
| **Default VPC** | Existing AWS resource | Network infrastructure |
| **Elastic IP** | Public IP assigned | Access Nginx via public IP |

## 📦 Project Files

```
terraform-nginx-ubuntu/
├── main.tf              # EC2, security group, and data sources
├── provider.tf          # AWS provider and required versions
├── variables.tf         # Input variables for customization
├── outputs.tf           # Outputs: public IP and Nginx URL
├── iam.tf               # IAM roles and policies
├── keypair.tf           # SSH key pair generation
├── user_data.sh         # Bash script for Nginx setup
├── terraform.tfvars     # (Optional) Variable values
├── .terraform/          # Generated provider cache
├── .terraform.lock.hcl  # Provider version lock file
└── README.md            # This file
```

## 🔧 Prerequisites

1. **AWS Account** with appropriate IAM permissions:
   - `ec2:RunInstances`
   - `ec2:CreateSecurityGroup`
   - `ec2:AuthorizeSecurityGroupIngress`
   - `ec2:CreateKeyPair`
   - `ec2:CreateTags`
   - `ec2:DescribeImages`
   - `ec2:DescribeVpcs`
   - `iam:CreateRole` and `iam:AttachRolePolicy`

2. **Terraform** (v1.0+)
   ```bash
   terraform version
   ```

3. **AWS CLI** (optional, for verification)
   ```bash
   aws --version
   ```

4. **AWS Credentials** configured
   ```bash
   aws configure
   ```

## 🚀 Getting Started

### Step 1: Clone or Download the Project

```bash
cd terraform-nginx-ubuntu
```

### Step 2: Initialize Terraform

Downloads required providers (AWS, TLS, Local) and sets up the working directory:

```bash
terraform init
```

### Step 3: Review the Plan

Preview all resources that will be created:

```bash
terraform plan
```

### Step 4: Apply the Configuration

**Option A: Interactive mode** (review before applying)
```bash
terraform apply
```
When prompted, type `yes` to confirm.

**Option B: Auto-approve** (apply without prompt)
```bash
terraform apply -auto-approve
```

### Step 5: Access Your Nginx Server

After deployment completes, Terraform outputs will display:

```
Outputs:

instance_public_ip = "13.40.177.149"
nginx_website_url = "http://13.40.177.149"
```

Visit the URL in your browser to see the custom welcome page.

## 📝 Configuration Details

### EC2 Instance Configuration

- **Instance Type:** t2.micro (free tier eligible)
- **AMI:** Ubuntu 20.04 LTS (latest canonical-provided image)
- **Availability Zone:** Auto-selected from default VPC
- **Public IP:** Automatically assigned and associated
- **User Data:** Executes `user_data.sh` on first launch

### Security Group Rules

| Direction | Protocol | Port | CIDR | Purpose |
|-----------|----------|------|------|---------|
| Inbound | TCP | 80 | 0.0.0.0/0 | HTTP traffic |
| Inbound | TCP | 22 | 0.0.0.0/0 | SSH access |
| Outbound | All | All | 0.0.0.0/0 | All traffic |

### Nginx Setup (user_data.sh)

The user data script performs:
1. System package update (`apt-get update`)
2. Nginx installation (`apt-get install -y nginx`)
3. Custom index page creation with welcome message
4. Nginx service enablement and startup

## 🔐 SSH Access

To connect to your instance via SSH:

```bash
# Copy your private key from the project directory
ssh -i adish-nginx-keypair.pem ubuntu@<instance_public_ip>
```

**Example:**
```bash
ssh -i adish-nginx-keypair.pem ubuntu@13.40.177.149
```

## 📊 Terraform Variables

Customize deployment by editing `variables.tf`:

```hcl
variable "aws_region" {
  default = "eu-west-2"        # AWS region
}

variable "instance_type" {
  default = "t2.micro"         # EC2 instance type
}

variable "key_name" {
  default = "adish-nginx-keypair"  # SSH key name
}
```

Or pass variables at runtime:

```bash
terraform apply -var="aws_region=us-east-1" -auto-approve
```

## 📤 Outputs

Terraform displays these values after successful deployment:

- **instance_public_ip:** Public IP address to access Nginx
- **nginx_website_url:** Direct URL with HTTP protocol

Retrieve outputs anytime:

```bash
terraform output
terraform output instance_public_ip
terraform output nginx_website_url
```

## 🗑️ Cleanup - Destroy Resources

Remove all resources created by this configuration:

```bash
terraform destroy
```

Confirm with `yes` when prompted. This will delete:
- EC2 instance
- Security groups
- IAM roles
- Key pairs
- All associated resources

### Auto-Approve Destroy (Caution!)

```bash
terraform destroy -auto-approve
```

## 🔄 Common Commands

| Command | Purpose |
|---------|---------|
| `terraform init` | Initialize working directory |
| `terraform plan` | Preview changes |
| `terraform apply` | Apply configuration (interactive) |
| `terraform apply -auto-approve` | Apply without confirmation |
| `terraform destroy` | Remove all resources (interactive) |
| `terraform output` | Display output values |
| `terraform validate` | Validate configuration syntax |
| `terraform fmt` | Format code |
| `terraform state list` | List all resources in state |

## 🐛 Troubleshooting

### Error: "UnauthorizedOperation"
Your AWS user lacks required permissions. Attach `AmazonEC2FullAccess` or equivalent policy.

### Error: "InvalidGroup.Duplicate"
Security group already exists. Either:
- Delete manually via AWS console
- Import into state: `terraform import aws_security_group.nginx_sg sg-xxxxx`

### Error: "resource not found"
Terraform state is out of sync. Run:
```bash
terraform refresh
terraform plan
```

## 📚 Best Practices Implemented

✅ Infrastructure as Code (IaC) - All resources defined in code  
✅ Version Control - Compatible with Git  
✅ Modular Design - Separated configuration files  
✅ Variable Inputs - Customizable without code changes  
✅ Output Values - Easy resource access  
✅ Resource Tagging - Organized with Name, Environment, ManagedBy tags  
✅ State Management - Terraform state tracks resource lifecycle  
✅ Security - SSH key pair for secure access  
✅ Documentation - Comprehensive README with examples  

## 📖 Additional Resources

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Nginx Documentation](https://nginx.org/en/docs/)

## 📝 License

This project is provided as-is for educational and assignment purposes.

## ⚠️ Important Notes

- This configuration uses the **default VPC** - no new VPC is created
- Resources are tagged for easy tracking and cost allocation
- Keep your private key (`adish-nginx-keypair.pem`) secure
- Monitor AWS console for resource usage and costs
- Destroy resources when no longer needed to avoid charges
