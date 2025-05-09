#!/bin/bash
# Update system packages
sudo apt-get update
sudo apt-get upgrade -y

# Install Apache web server
sudo apt-get install -y apache2

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2

# Create HTML content
sudo bash -c 'echo "<html><body><h1>Hello, World!</h1></body></html>" > /var/www/html/index.html'

# Set proper permissions
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html