#!/bin/bash

# Step 1: Install Required Software on Ubuntu
echo "Step 1: Installing Required Software on Ubuntu"
sudo apt update
sudo apt install -y apache2 mysql-server php php-mysql php-curl php-gd php-json php-mbstring php-xml php-zip

# Step 2: Configure MySQL
echo "Step 2: Configuring MySQL"
sudo mysql_secure_installation
mysql -u root -p <<MYSQL_SCRIPT
CREATE DATABASE wordpress;
CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
MYSQL_SCRIPT

# Step 3: Install WordPress
echo "Step 3: Installing WordPress"
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
sudo mv wordpress /var/www/html/
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress

# Step 4: Configure Apache
echo "Step 4: Configuring Apache"
sudo tee /etc/apache2/sites-available/wordpress.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerAdmin tekno@teknopathshala.com
    DocumentRoot /var/www/html/wordpress
    ServerName tekno.com
    ServerAlias www.tekno.com

    <Directory /var/www/html/wordpress/>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

sudo a2ensite wordpress.conf
sudo a2enmod rewrite
sudo systemctl restart apache2

echo "WordPress installation and configuration completed!"
