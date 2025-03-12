#!/bin/bash
# Update packages and install Nginx
apt update -y
apt install -y nginx

# Fetch the instance's private IP
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Create an HTML page displaying the instance's IP
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>EC2 Instance</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
        h1 { color: #0073e6; }
    </style>
</head>
<body>
    <h1>Welcome to Nginx on AWS EC2</h1>
    <h2>Instance Private IP: $PRIVATE_IP</h2>
</body>
</html>
EOF

# Ensure Nginx starts and enable it on boot
systemctl restart nginx
systemctl enable nginx
