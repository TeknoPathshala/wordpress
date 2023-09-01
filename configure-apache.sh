#!/bin/bash

# Define the WordPress domain name or IP address
WORDPRESS_DOMAIN='192.168.1.253'

# Create the directory if it doesn't exist
sudo mkdir -p /etc/apache2/sites-available/

# Define the virtual host configuration
cat <<EOF | sudo tee /etc/apache2/sites-available/${WORDPRESS_DOMAIN}.conf > /dev/null
<VirtualHost *:80>
    ServerAdmin webmaster@${WORDPRESS_DOMAIN}
    DocumentRoot /var/www/html/wordpress
    ServerName ${WORDPRESS_DOMAIN}
    ServerAlias www.${WORDPRESS_DOMAIN}

    <Directory /var/www/html/wordpress/>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/${WORDPRESS_DOMAIN}-error.log
    CustomLog \${APACHE_LOG_DIR}/${WORDPRESS_DOMAIN}-access.log combined
</VirtualHost>
EOF

# Enable the virtual host and restart Apache
sudo a2ensite ${WORDPRESS_DOMAIN}.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
