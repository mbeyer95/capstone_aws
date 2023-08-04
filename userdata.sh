#!/bin/bash

sudo yum update -y

sudo yum install -y httpd mariadb-server php php-mysqlnd unzip
sudo systemctl start httpd
sudo systemctl enable httpd

cd /var/www/html
aws s3 sync s3://deham6-wordpress/
