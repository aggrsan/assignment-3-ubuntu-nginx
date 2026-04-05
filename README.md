# Terraform Nginx Ubuntu Deployment

This Terraform project provisions an AWS EC2 instance running Ubuntu 20.04 LTS with Nginx installed and a custom welcome page.

## Resources Created

- AWS provider configured for the selected region
- Default VPC and default subnet are used
- Security group allowing inbound HTTP (80) and SSH (22)
- `t2.micro` Ubuntu 20.04 LTS EC2 instance
- `user_data` script installs Nginx and replaces the default index page
- Output of the instance public IP

## Files

- `main.tf` - Terraform configuration for provider, data sources, security group, and EC2 instance
- `variables.tf` - Input variables for AWS region, instance type, and optional SSH key name
- `outputs.tf` - Public IP output for the EC2 instance
- `README.md` - Instructions for running the project

## How to Run

1. Open a terminal in this folder.
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Review the planned changes:
   ```bash
   terraform plan
   ```
4. Apply the configuration:
   ```bash
   terraform apply
   ```
5. When prompted, confirm with `yes`.
6. After provisioning completes, note the `instance_public_ip` output.
7. Visit `http://<instance_public_ip>` in a browser to see the custom Nginx page.

## Destroy Resources

To remove all resources created by this configuration:

```bash
terraform destroy
```

Then confirm with `yes`.

## Notes

- This configuration uses the AWS default VPC and default subnet only.
- No separate VPC, subnet, or internet gateway is created.
- If you want SSH access, set `key_name` in `variables.tf` or via `-var="key_name=<key>"`.
