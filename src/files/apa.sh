#!/bin/bash

# Function to install expect if not already installed
install_expect() {
    echo "Checking for 'expect' package..."
    if ! command -v expect &> /dev/null; then
        echo "'expect' not found. Installing..."
        apt update -y
        apt install expect -y
    else
        echo "'expect' is already installed."
    fi
}

# Function to install required packages
install_packages() {
    echo "Installing Apache2, PHP, phpMyAdmin, MariaDB, wget, unzip, and curl..."
    apt update -y
    apt install apache2 php phpmyadmin mariadb-server wget unzip curl -y
}

# Prompt for database details
get_db_details() {
    echo "Please enter the WordPress database details:"

    # Ask for database name
    printf "%-50s" "Enter the name for the WordPress database (default: wordpress):"
    read DB_NAME
    DB_NAME=${DB_NAME:-wordpress}  # Default to 'wordpress' if empty input

    # Ask for username
    printf "%-50s" "Enter the username for the WordPress database user (default: wpuser):"
    read DB_USER
    DB_USER=${DB_USER:-wpuser}  # Default to 'wpuser' if empty input

    # Ask for password
    printf "%-50s" "Enter the password for the WordPress database user (default: password):"
    read -s DB_PASS
    DB_PASS=${DB_PASS:-password}  # Default to 'password' if empty input
}

# Ensure the WordPress directory exists
create_wordpress_dir() {
    if [ ! -d "/var/www/html/wordpress" ]; then
        echo "Creating directory for WordPress..."
        mkdir /var/www/html/wordpress
    fi
}

# Download and unzip WordPress
download_and_unzip_wordpress() {
    echo "Downloading WordPress..."
    wget http://172.16.90.2/unduh/wordpress.zip -P /var/www/html/

    if [ ! -f "/var/www/html/wordpress.zip" ]; then
        echo "WordPress download failed. Exiting."
        exit 1
    fi

    echo "Unzipping WordPress..."
    unzip -o /var/www/html/wordpress.zip -d /var/www/html/wordpress/
}

# Set the appropriate permissions
set_permissions() {
    echo "Setting permissions for WordPress directory..."
    chmod -R 755 /var/www/html/wordpress

    echo "Setting permissions for wp-config.php..."
    chmod 644 /var/www/html/wordpress/wp-config.php
}

# Automate MySQL secure installation
mysql_secure_installation() {
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
}

# Create the database and user
create_database_and_user() {
    echo "Creating WordPress database and user..."

    # Initialize MySQL
    mysql -u root -prootpassword <<EOF
CREATE DATABASE ${DB_NAME};
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF
}

# Configure wp-config.php
configure_wp_config() {
    echo "Configuring wp-config.php..."

    # Copy the sample config file
    cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

    # Replace the database name, user, and password in wp-config.php
    sed -i "s/database_name_here/${DB_NAME}/" /var/www/html/wordpress/wp-config.php
    sed -i "s/username_here/${DB_USER}/" /var/www/html/wordpress/wp-config.php
    sed -i "s/password_here/${DB_PASS}/" /var/www/html/wordpress/wp-config.php
}

# Restart Apache
restart_apache() {
    echo "Restarting Apache server..."
    systemctl restart apache2
}

# Main script execution
main() {
    install_expect
    install_packages
    get_db_details
    create_wordpress_dir
    download_and_unzip_wordpress
    set_permissions
    mysql_secure_installation
    create_database_and_user
    configure_wp_config
    restart_apache

    # Final message
    echo "WordPress installation is complete!"
    echo "You can now access your WordPress site at: http://<your-server-ip>/wordpress"

    # Watermark / Signature at the end of the script
    echo "--------------------------------------------------"
    echo "Script created by: aboo"
    echo "For more info, visit: abooo.vercel.app"
    echo "Terimakasih telah menggunakan script aboo!"
    echo "--------------------------------------------------"
}

# Run the main function
main
