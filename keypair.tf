# Generate SSH key pair
resource "tls_private_key" "terraform_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create AWS key pair
resource "aws_key_pair" "terraform_keypair" {
  key_name   = var.key_name
  public_key = tls_private_key.terraform_key.public_key_openssh
}

# Save private key to local file
resource "local_file" "private_key" {
  filename        = "${path.module}/adish-nginx-keypair.pem"
  content         = tls_private_key.terraform_key.private_key_pem
  file_permission = "0400"
}