#!/bin/bash

# Ensure the script is running as root (or with sudo)
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Install expect if it's not installed already
echo "Checking if 'expect' is installed..."
if ! command -v expect &>/dev/null; then
    echo "'expect' is not installed. Installing it now..."
    apt install expect -y
else
    echo "'expect' is already installed."
fi

# Ask user for database details
echo "Please enter the WordPress database details:"

# Default values
DB_NAME=${DB_NAME:-wordpress}
DB_USER=${DB_USER:-wpuser}
DB_PASS=${DB_PASS:-password}

# Update and Install necessary packages
echo "Updating and Installing Apache2, PHP, phpMyAdmin, MariaDB, wget, unzip, curl..."
apt update -y
apt install apache2 php phpmyadmin mariadb-server wget unzip curl -y

# Change to the web server's root directory
echo "Changing directory to /var/www/html/..."
cd /var/www/html/

# Download WordPress
echo "Downloading WordPress from the local server..."
wget http://172.16.90.2/unduh/wordpress.zip

# Unzip the WordPress package
echo "Unzipping WordPress..."
unzip wordpress.zip

# Set the appropriate permissions for the WordPress directory
echo "Setting permissions for WordPress directory..."
chmod -R 755 wordpress

# Automating MySQL secure installation
echo "Running mysql_secure_installation automatically..."
SECURE_MYSQL=$(expect -c "
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"\r\"
expect \"Set root password? [Y/n]\"
send \"Y\r\"
expect \"New password:\"
send \"rootpassword\r\"
expect \"Re-enter new password:\"
send \"rootpassword\r\"
expect \"Remove anonymous users? [Y/n]\"
send \"Y\r\"
expect \"Disallow root login remotely? [Y/n]\"
send \"Y\r\"
expect \"Remove test database and access to it? [Y/n]\"
send \"Y\r\"
expect \"Reload privilege tables now? [Y/n]\"
send \"Y\r\"
expect eof
")

echo "$SECURE_MYSQL"

# Run SQL commands to create the database and user
echo "Creating WordPress database and user..."
mysql -u root -prootpassword <<EOF
CREATE DATABASE ${DB_NAME};
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

# Configure wp-config.php with the database details
echo "Configuring wp-config.php..."

# Copy the sample config file
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

# Replace the database name, user, and password in wp-config.php
sed -i "s/database_name_here/${DB_NAME}/" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/${DB_USER}/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/${DB_PASS}/" /var/www/html/wordpress/wp-config.php

# Set permissions for the wp-config.php file (important for security)
chmod 644 /var/www/html/wordpress/wp-config.php

# Restart Apache to ensure the web server is up-to-date
echo "Restarting Apache server..."
systemctl restart apache2

# Final message
echo "WordPress installation is complete!"
echo "You can now access your WordPress site at: http://<your-server-ip>/wordpress"

# Watermark / Signature at the end of the script
echo "--------------------------------------------------"
echo "Script created by: aboo"
echo "For more info, visit: abooo.vercel.app"
echo "terimakasih telah menggunakan skip aboo"
echo "--------------------------------------------------"
