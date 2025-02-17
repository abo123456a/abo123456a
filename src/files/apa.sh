#!/bin/bash

# Set mode non-interaktif untuk mencegah prompt
export DEBIAN_FRONTEND=noninteractive

# Atur password phpMyAdmin sebelum instalasi untuk menghindari prompt
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password rootpassword" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password rootpassword" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password rootpassword" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

# Instalasi paket yang diperlukan
echo "Installing Apache2, PHP, phpMyAdmin, MariaDB, wget, unzip, and curl..."
apt update -y
apt install apache2 php phpmyadmin mariadb-server wget unzip curl -y

# Pindah ke direktori root web server
cd /var/www/html/

# Download dan ekstrak WordPress
echo "Downloading WordPress..."
wget http://172.16.90.2/unduh/wordpress.zip
unzip wordpress.zip

# Beri izin akses ke folder WordPress
chmod -R 777 wordpress

# Konfigurasi otomatis mysql_secure_installation
echo "Running mysql_secure_installation automatically..."
apt install expect -y

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

# Buat database dan user untuk WordPress
mysql -u root -prootpassword <<EOF
CREATE DATABASE wordpress;
CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';
FLUSH PRIVILEGES;
EOF

# Konfigurasi wp-config.php
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sed -i "s/database_name_here/wordpress/" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/wpuser/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/password/" /var/www/html/wordpress/wp-config.php
chmod 644 /var/www/html/wordpress/wp-config.php

# Restart Apache
systemctl restart apache2

# Pesan akhir
echo "WordPress installation is complete!"
echo "You can now access your WordPress site at: http://<your-server-ip>/wordpress"

echo "--------------------------------------------------"
echo "Script created by: aboo"
echo "For more info, visit: abooo.vercel.app"
echo "Terima kasih telah menggunakan skrip aboo!"
echo "--------------------------------------------------"
