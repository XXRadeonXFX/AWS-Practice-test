# Install python3-venv if not already installed
sudo apt update
sudo apt install -y python3-venv

# Create a virtual environment
python3 -m venv ~/flask_env

# Activate the virtual environment
source ~/flask_env/bin/activate

# Now install Flask in the virtual environment
pip install flask