I'll provide clear instructions for all tasks using Ubuntu 24.04 LTS. Here's a comprehensive guide:

# Task 1: Web Page on an EC2 Instance (Ubuntu 24.04)

## Launch an EC2 Instance
1. Log into AWS Console and go to EC2 dashboard
2. Click "Launch Instance"
3. Select "Ubuntu Server 24.04 LTS" AMI
4. Choose t2.micro instance type
5. Configure instance details:
   - Select your VPC (default or custom)
   - Choose a public subnet
   - Enable auto-assign public IP

## Security Group Configuration
1. Create new security group named "Web-Server-SG"
2. Add rule: SSH (port 22) - Source: Your IP
3. Add rule: HTTP (port 80) - Source: 0.0.0.0/0

## User Data Script
Paste this in the "User data" section:
```bash
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
```

## Launch and Connect
1. Choose an existing or create a new key pair
2. Launch the instance
3. Connect with: `ssh -i your-key.pem ubuntu@your-public-ip`

## Verify
1. Open browser and go to http://your-public-ip
2. You should see "Hello, World!"

# Task 2: Deploy a Flask Application (Ubuntu 24.04)

## Launch EC2 Instance
1. Launch another Ubuntu 24.04 instance following Task 1 steps
2. Security Group: Allow SSH (22) and HTTP (80 and 8080)

## Install Flask (SSH into your instance first)
```bash
sudo apt-get update
sudo apt-get install -y python3 python3-pip
sudo pip3 install flask
```

## Create Flask App
```bash
mkdir -p ~/flask_app
cd ~/flask_app
```

Create app.py:
```bash
cat > app.py << EOF
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Your name"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
EOF
```

## Run Flask Application
```bash
# Start the application
nohup python3 app.py > output.log 2>&1 &

# Verify it's running
ps aux | grep python3
```

## Verify
1. Open browser and go to http://your-public-ip:8080
2. You should see "Your name"

# Task 3: Add Routes to Flask Application

## Modify app.py
```bash
cd ~/flask_app
```

Edit app.py:
```bash
cat > app.py << EOF
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Welcome to my Flask Application!"

@app.route('/about')
def about():
    return "This is a simple Flask application deployed on AWS EC2."

@app.route('/contact')
def contact():
    return "Contact me at: your-email@example.com"

@app.route('/status')
def status():
    return "Application is running normally."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
EOF
```

## Restart Flask Application
```bash
# Find and kill the running Flask process
ps aux | grep python3
kill $(pgrep -f "python3 app.py")

# Start the application again
nohup python3 app.py > output.log 2>&1 &
```

## Verify Routes
Test each route in your browser:
- http://your-public-ip:8080/ (Homepage)
- http://your-public-ip:8080/about
- http://your-public-ip:8080/contact
- http://your-public-ip:8080/status

# Task 4: S3 Static Website for Portfolio

## Create S3 Bucket
1. Go to S3 Console
2. Click "Create bucket"
3. Enter unique name (e.g., "your-name-portfolio")
4. Select a region
5. Uncheck "Block all public access"
6. Acknowledge the warning
7. Click "Create bucket"

## Enable Static Website Hosting
1. Select your bucket
2. Go to "Properties" tab
3. Scroll to "Static website hosting"
4. Click "Edit"
5. Select "Enable"
6. Enter "index.html" for Index document
7. Click "Save changes"

## Upload Files
Create a basic index.html:
```html
<!DOCTYPE html>
<html>
<head>
    <title>My Portfolio</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            line-height: 1.6;
        }
        h1 {
            color: #333;
        }
    </style>
</head>
<body>
    <h1>My Portfolio</h1>
    <p>Welcome to my personal portfolio website hosted on Amazon S3.</p>
    <h2>About Me</h2>
    <p>I am a cloud computing enthusiast learning AWS services.</p>
    <h2>My Projects</h2>
    <ul>
        <li>EC2 Web Server</li>
        <li>Flask Application Deployment</li>
        <li>S3 Static Website</li>
    </ul>
</body>
</html>
```

Upload this file to your S3 bucket.

## Set Permissions
1. Go to "Permissions" tab
2. Click "Edit" under "Bucket policy"
3. Paste this policy (replace YOUR-BUCKET-NAME):
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*"
        }
    ]
}
```
4. Click "Save changes"

## Access Website
1. Go to "Properties" tab
2. Scroll to "Static website hosting"
3. Copy the website endpoint URL
4. Open it in your browser

# Task 5: Dockerized Web Application on EC2 (Ubuntu 24.04)

## Launch Two EC2 Instances
1. Launch two Ubuntu 24.04 instances
2. Security Group: Allow SSH (22) and HTTP (80)

## User Data Script
Paste this in the "User data" section:
```bash
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
```

## Verify
1. SSH into each instance after it's launched
2. Run `docker ps` to check if container is running
3. Open browser and go to http://public-ip-of-instance-1 and http://public-ip-of-instance-2

# Task 6: Custom AMI with Docker

## Prepare EC2 Instance
1. Choose one instance from Task 5
2. Verify Docker is running: `sudo systemctl status docker`
3. Create a test file to confirm AMI works: `echo "AMI Test" > ~/ami-test.txt`

## Create Custom AMI
1. Go to EC2 Dashboard
2. Select the instance
3. Click "Actions" > "Image and templates" > "Create image"
4. Set:
   - Name: "Ubuntu-24-Docker-AMI"
   - Description: "Ubuntu 24.04 with Docker pre-installed"
5. Click "Create image"
6. Wait for AMI creation to complete (check AMIs section)

## Launch Instance from Custom AMI
1. Go to AMIs section
2. Select your AMI
3. Click "Launch instance from AMI"
4. Configure:
   - Same instance type
   - Same security group
5. Launch the instance

## Verify Docker Installation
1. SSH into the new instance
2. Run:
   ```bash
   # Check Docker version
   docker --version
   
   # Check Docker service
   sudo systemctl status docker
   
   # Check for running containers
   docker ps
   
   # Verify test file exists
   cat ~/ami-test.txt
   ```

# Task 7: Load Balancer for Dockerized Applications

## Create Application Load Balancer
1. Go to EC2 Dashboard > "Load Balancers"
2. Click "Create Load Balancer"
3. Select "Application Load Balancer"
4. Configure:
   - Name: "Docker-Web-ALB"
   - Scheme: Internet-facing
   - IP address type: IPv4
   - VPC: Your VPC
   - Mappings: Select at least two AZs and public subnets

## Create Security Group for ALB
1. Create a new security group: "ALB-SG"
2. Add rule: HTTP (80) - Source: 0.0.0.0/0

## Create Target Group
1. Click "Create target group"
2. Configure:
   - Target type: Instances
   - Name: "Docker-Web-TG"
   - Protocol: HTTP, Port: 80
   - VPC: Your VPC
   - Health check path: "/"
3. Click "Next"
4. Register the two EC2 instances from Task 5
5. Click "Create target group"

## Complete ALB Creation
1. Return to load balancer creation
2. Select the new security group
3. Configure listener:
   - Protocol: HTTP, Port: 80
   - Default action: Forward to Docker-Web-TG
4. Click "Create load balancer"

## Verify ALB
1. Wait for the ALB to be active
2. Copy the DNS name
3. Open in browser
4. Refresh multiple times to see traffic distribution

# Task 8: Dockerized Node.js with ECR and ECS

## Create a Node.js Application (Local Machine)
Create a project folder with these files:

app.js:
```javascript
const express = require('express');
const app = express();
const port = 8080;

app.get('/', (req, res) => {
  res.send('Travel Memory App');
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
```

package.json:
```json
{
  "name": "travel-memory-app",
  "version": "1.0.0",
  "main": "app.js",
  "dependencies": {
    "express": "^4.17.1"
  }
}
```

Dockerfile:
```dockerfile
FROM ubuntu:24.04

# Prevent interactive dialogs
ENV DEBIAN_FRONTEND=noninteractive

# Update and install Node.js
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy application code
COPY . .

EXPOSE 8080

CMD ["node", "app.js"]
```

## Build Docker Image (Local Machine)
```bash
docker build -t travel-memory-app-prince .
```

## Create ECR Repository
1. Go to Amazon ECR console
2. Click "Create repository"
3. Name: "travel-memory-app-prince"
4. Click "Create repository"

## Push Image to ECR
In your terminal:
```bash
# Get login command (use your region)
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 975050024946.dkr.ecr.ap-south-1.amazonaws.com

# Tag the image
docker tag travel-memory-app-prince:latest 975050024946.dkr.ecr.ap-south-1.amazonaws.com/travel-memory-app-prince:latest

# Push the image
docker push 975050024946.dkr.ecr.ap-south-1.amazonaws.com/travel-memory-app-prince:latest
```

## Create ECS Cluster
1. Go to ECS console
2. Click "Create Cluster"
3. Configure:
   - Cluster name: "travel-app-cluster"
   - Infrastructure: AWS Fargate (serverless)
4. Click "Create"

## Create Task Definition
1. Go to "Task Definitions"
2. Click "Create new Task Definition"
3. Select "Fargate"
4. Configure:
   - Task Definition Name: "travel-app-task"
   - Task Role: ecsTaskExecutionRole
   - Network Mode: awsvpc
   - Task memory: 1GB
   - Task CPU: 0.5 vCPU
5. Add container:
   - Container name: "travel-app-container"
   - Image: Your ECR image URI
   - Port mappings: Container port 8080
6. Click "Create"

## Create ALB for ECS
1. Create an Application Load Balancer
2. Configure as in Task 7, with these differences:
   - Target group: Create a new target group
   - Target type: IP
   - Protocol: HTTP
   - Port: 8080

## Create ECS Service
1. Go to your ECS cluster
2. Click "Create Service"
3. Configure:
   - Launch type: Fargate
   - Platform version: LATEST
   - Task Definition: travel-app-task
   - Service name: "travel-app-service"
   - Number of tasks: 2
4. Under networking:
   - VPC: Your VPC
   - Subnets: Select at least two public subnets
   - Security group: Create new with HTTP 8080 open
  ``` 
   Configure Security Group Rules
  - Under "Inbound rules", click "Add rule"
  - Configure the rule:
  - Type      : Custom TCP
  - Protocol  : TCP
  - Port range: 8080
  - Source    : Anywhere (0.0.0.0/0)
  - You can add a description: "Allow HTTP traffic on port 8080"
  ```
5. Load balancing:
   - Type: Application Load Balancer
   - Select your ALB and target group
6. Click "Create Service"

## Verify Deployment
1. Wait for the service to be running
2. Go to the load balancer DNS name
3. You should see "Travel Memory App"

These comprehensive instructions should help you complete all the AWS tasks successfully using Ubuntu 24.04 LTS.