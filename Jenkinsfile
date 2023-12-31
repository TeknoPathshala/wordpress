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
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GitHub', url: "${GITHUB_REPO_URL}"]]])
            }
        }
        stage('Fetch WordPress Installation Script') {
            steps {
                // Fetch the WordPress installation script
                sh "wget -O wordpress-install.sh ${SCRIPT_URL}"
                
                // Make the script executable
                sh "chmod +x wordpress-install.sh"
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
                // Execute the Apache configuration script with sudo using the correct path
                sh "sudo /var/lib/jenkins/workspace/wordpress/configure-apache.sh"
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
