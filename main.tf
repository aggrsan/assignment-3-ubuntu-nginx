# ---------------------------------------------------------------------------------------------------------------------
# main.tf - EC2 instance with Nginx using Terraform
# ---------------------------------------------------------------------------------------------------------------------

# AWS provider configuration is defined in provider.tf

# ---------------------------------------------------------------------------------------------------------------------
# DATA SOURCES – reference existing AWS resources (default VPC, subnets, Ubuntu AMI)
# ---------------------------------------------------------------------------------------------------------------------

# Get the default VPC for the account
data "aws_vpc" "default" {
  default = true
}

# Retrieve the available subnets inside the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get the latest Ubuntu 20.04 LTS AMI (canonical, x86_64, HVM, EBS)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Get the existing security group
data "aws_security_group" "nginx_sg" {
  name   = "terraform-nginx-sg"
  vpc_id = data.aws_vpc.default.id
}

# EC2 INSTANCE – t2.micro, Ubuntu 20.04, user_data to install Nginx and custom page
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "nginx" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0] # pick first default subnet
  vpc_security_group_ids      = [data.aws_security_group.nginx_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  key_name                    = var.key_name
  user_data                   = file("${path.module}/user_data.sh")

  tags = {
    Name        = "terraform-nginx-ubuntu"
    Environment = "assignment"
    ManagedBy   = "Terraform"
  }
}