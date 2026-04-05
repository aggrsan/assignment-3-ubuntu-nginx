# ---------------------------------------------------------------------------------------------------------------------
# outputs.tf – Display useful information after apply
# ---------------------------------------------------------------------------------------------------------------------

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance running Nginx"
  value       = aws_instance.nginx.public_ip
}

output "nginx_website_url" {
  description = "URL to access the Nginx web server"
  value       = "http://${aws_instance.nginx.public_ip}"
}