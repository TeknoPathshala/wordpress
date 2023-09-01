pipeline {
    agent any
    environment {
        // Define the WordPress domain name or IP address
        WORDPRESS_DOMAIN = '192.168.1.253'
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout your GitHub repository
                checkout scm
            }
        }
        stage('Install WordPress') {
            steps {
                // Execute the WordPress installation script
                sh './wordpress-install.sh'
            }
        }
        stage('Configure Apache') {
            steps {
                // Configure Apache to serve WordPress
                sh "sudo tee /etc/apache2/sites-available/${WORDPRESS_DOMAIN}.conf > /dev/null <<EOF
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
EOF"
                // Enable the virtual host and restart Apache
                sh "sudo a2ensite ${WORDPRESS_DOMAIN}.conf"
                sh "sudo a2enmod rewrite"
                sh "sudo systemctl restart apache2"
            }
        }
    }
}
