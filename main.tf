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
# Security group for the EC2 instance
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "nginx_sg" {
  name        = "terraform-nginx-sg"
  description = "Allow HTTP and SSH access to the Nginx instance"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "terraform-nginx-sg"
    Environment = "assignment"
    ManagedBy   = "Terraform"
  }
}

# EC2 INSTANCE – t2.micro, Ubuntu 20.04, user_data to install Nginx and custom page
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "nginx" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0] # pick first default subnet
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]
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