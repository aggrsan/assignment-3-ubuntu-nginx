#!/bin/bash
set -e
apt-get update -y
apt-get install -y nginx
# Overwrite the default Nginx index page
echo '<!DOCTYPE html>
<html>
<head>
    <title>Terraform Nginx</title>
</head>
<body>
    <h1>Welcome to the Terraform-managed Nginx Server on Ubuntu</h1>
</body>
</html>' > /var/www/html/index.html
systemctl enable nginx
systemctl start nginx
