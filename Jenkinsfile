pipeline {
    agent any
    environment {
        // Define the WordPress domain name or IP address
        WORDPRESS_DOMAIN = '192.168.1.253'
        // Define the GitHub repository URL and script URL
        GITHUB_REPO_URL = 'https://github.com/TeknoPathshala/wordpress.git'
        SCRIPT_URL = 'https://raw.githubusercontent.com/TeknoPathshala/wordpress/main/wordpress-install.sh'
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout your GitHub repository
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'your-credentials-id', url: "${GITHUB_REPO_URL}"]]])
            }
        }
        stage('Fetch WordPress Installation Script') {
            steps {
                // Fetch the WordPress installation script
                sh "wget -O wordpress-install.sh ${SCRIPT_URL}"
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
                script {
                    // Define the virtual host configuration as a multi-line string
                    def virtualHostConfig = """
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
"""

                    // Use 'echo' to print the multi-line string and write it to the file
                    sh """echo '''${virtualHostConfig}''' | sudo tee /etc/apache2/sites-available/${WORDPRESS_DOMAIN}.conf > /dev/null"""

                    // Enable the virtual host and restart Apache
                    sh "sudo a2ensite ${WORDPRESS_DOMAIN}.conf"
                    sh "sudo a2enmod rewrite"
                    sh "sudo systemctl restart apache2"
                }
            }
        }
        stage('Access WordPress Website') {
            steps {
                // Display the URL for accessing the WordPress website
                script {
                    echo "You can access your WordPress website at: http://${WORDPRESS_DOMAIN}"
                }
            }
        }
    }
}
