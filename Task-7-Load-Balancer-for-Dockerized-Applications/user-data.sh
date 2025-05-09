#!/bin/bash
# Update system packages
sudo apt-get update
sudo apt-get upgrade -y

# Install required packages
sudo apt-get install -y ca-certificates curl gnupg

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists
sudo apt-get update

# Install Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Pull and run nginx container
sudo docker pull nginx
sudo docker run -d --name web-app -p 80:80 nginx

# Create a custom index.html
sudo mkdir -p /docker-content
sudo bash -c 'cat > /docker-content/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Dockerized Web App</title>
</head>
<body>
    <h1>Hello from Docker!</h1>
    <p>This is a Dockerized web application running on EC2.</p>
</body>
</html>
EOF'

# Stop the default container
sudo docker stop web-app
sudo docker rm web-app

# Run with custom content
sudo docker run -d --name web-app -p 80:80 -v /docker-content:/usr/share/nginx/html nginx