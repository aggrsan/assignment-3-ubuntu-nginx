# ---------------------------------------------------------------------------------------------------------------------
# variables.tf – Input variables for the Terraform configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-west-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}


# Optional: SSH key pair name – if left empty, no key will be attached
variable "key_name" {
  description = "Name of an existing EC2 key pair (optional)"
  type        = string
  default     = "adish-nginx-keypair"
}

variable "tags_name_web" {
  type    = string
  default = "terraform-nginx-server"
}

variable "tags_name_db" {
  type    = string
  default = "terraform-db-server"
}