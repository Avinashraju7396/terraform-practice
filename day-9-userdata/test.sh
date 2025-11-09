#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>AWS Infra created using Terraform in us-west-1 Region</h1>" | sudo tee /var/www/html/index.html
sudo yum install -y git
