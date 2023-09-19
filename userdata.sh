#!/bin/bash

# update preinstalled packages
sudo yum update -y
# install Apache Web Server, start and enable it
sudo yum install -y httpd && sudo systemctl start httpd && sudo systemctl enable httpd
# install all necessary packages
sudo yum install -y wget php-fpm php-mysqli php-json php-devel php
sudo amazon-linux-extras enable php8.0
sudo yum install -y php-cli php-pdo php-fpm php-json php-mysqlnd php php-{mbstring,json,xml,mysqlnd}
sudo systemctl start php-fpm && sudo systemctl enable php-fpm
sudo yum install -y php
# install mariadb, start and enable it
sudo yum install -y mariadb-server && sudo systemctl start mariadb && sudo systemctl enable mariadb
# create a user named "ec2-user" on the Apache Web Server
sudo usermod -a -G apache ec2-user
# transmit ownership of this folder to the ec2-user
sudo chown -R ec2-user:apache /var/www
# searches for all files in the /var/www directory and its subdirectories, and then it sets the permissions so the owner can read and write, while the group and others can only read the file
find /var/www -type f -exec sudo chmod 0664 {} \;
# Copy Wordpress
cd ~
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo mv wordpress/* /var/www/html/
# configure database
sudo sed -i "s/database_name_here/${db_name}/g" /var/www/html/wp-config.php
sudo sed -i "s/username_here/${db_username}/g" /var/www/html/wp-config.php
sudo sed -i "s/password_here/${db_password}/g" /var/www/html/wp-config.php
sudo sed -i "s/localhost/${db_host}/" wp-config.php
# restart apache web server
sudo systemctl restart httpd