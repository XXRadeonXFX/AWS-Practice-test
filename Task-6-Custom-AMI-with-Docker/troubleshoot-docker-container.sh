# 1. Check if web-app1 was actually created and is running
docker ps

# 2. If web-app1 is not running, check if it was created at all
docker ps -a

# 3. If there was an issue with web-app1, try these steps:
# First, remove the old web-app container
sudo docker rm web-app

# Check if the /docker-content directory exists
sudo ls -la /docker-content

# If it doesn't exist, create it
sudo mkdir -p /docker-content

# Create a test HTML file
sudo bash -c 'echo "<html><body><h1>Hello from Docker!</h1><p>Container is working!</p></body></html>" > /docker-content/index.html'

# Now try running the container again with the original name
sudo docker run -d --name web-app -p 80:80 -v /docker-content:/usr/share/nginx/html nginx

# Verify it's running
docker ps

# Check the logs to see if there are any issues
docker logs web-app