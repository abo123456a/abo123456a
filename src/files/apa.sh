#!/bin/bash

# Ensure the script is running as root (or with sudo)
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Install necessary packages (Apache2, MariaDB, PHP, phpMyAdmin, etc.) in one go to speed up installation
echo "Installing Apache2, PHP, MariaDB, phpMyAdmin, wget, unzip, curl, and expect..."
apt update -y
apt install apache2 mariadb-server php phpmyadmin wget unzip curl expect -y

# Ensure PHP is installed and configured properly
echo "Configuring PHP..."
apt install php-mysqli php-xml php-curl php-mbstring php-zip php-soap -y

# Automatically set up MariaDB (MySQL)
echo "Securing MariaDB installation..."
mysql_secure_installation <<EOF

Y
rootpassword
rootpassword
Y
Y
Y
Y
EOF

# Ask user for database details (defaults are provided)
DB_NAME=${DB_NAME:-wordpress}
DB_USER=${DB_USER:-wpuser}
DB_PASS=${DB_PASS:-password}

# Create database and user for WordPress
echo "Creating WordPress database and user..."
mysql -u root -prootpassword <<EOF
CREATE DATABASE ${DB_NAME};
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

# Set up Apache2 for WordPress
echo "Setting up Apache2 for WordPress..."
cp /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
a2enconf phpmyadmin
systemctl restart apache2

# Change to the web server's root directory
echo "Changing directory to /var/www/html/..."
cd /var/www/html/

# Download WordPress
echo "Downloading WordPress..."
wget http://172.16.90.2/unduh/wordpress.zip

# Unzip the WordPress package
echo "Unzipping WordPress..."
unzip wordpress.zip

# Set the appropriate permissions for the WordPress directory
echo "Setting permissions for WordPress directory..."
chmod -R 755 wordpress

# Configure wp-config.php with database details
echo "Configuring wp-config.php..."

# Copy the sample config file
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

# Replace the database name, user, and password in wp-config.php
sed -i "s/database_name_here/${DB_NAME}/" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/${DB_USER}/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/${DB_PASS}/" /var/www/html/wordpress/wp-config.php

# Set permissions for wp-config.php (important for security)
chmod 644 /var/www/html/wordpress/wp-config.php

# Restart Apache2 server to apply changes
echo "Restarting Apache2..."
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
