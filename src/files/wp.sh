#!/bin/bash

# Update and Install necessary packages
echo "Installing Apache2, PHP, phpMyAdmin, MariaDB, wget, unzip, and curl..."
apt update -y
apt install apache2 php phpmyadmin mariadb-server wget unzip curl -y

# Change to the web server's root directory
echo "Changing directory to /var/www/html/"
cd /var/www/html/

# Download WordPress
echo "Downloading WordPress..."
wget http://172.16.90.2/unduh/wordpress.zip

# Unzip the WordPress package
echo "Unzipping WordPress..."
unzip wordpress.zip

# Set the appropriate permissions for the WordPress directory
echo "Setting permissions for WordPress directory..."
chmod -R 777 wordpress

# Secure MariaDB installation
echo "Securing MariaDB installation..."
mysql_secure_installation

# Login to MySQL as root
echo "Logging into MariaDB as root..."
mysql -u root -p
