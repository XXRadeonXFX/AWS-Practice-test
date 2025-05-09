
# 1. Install Python virtual environment package if not already installed
sudo apt update
sudo apt install -y python3-venv

# 2. Create a virtual environment in your flask_app directory
python3 -m venv venv

# 3. Activate the virtual environment
source venv/bin/activate

# 4. Now install your requirements (your prompt should show (venv) at the beginning)
pip install -r requirements.txt

# 5. Run your Flask application
python app.py