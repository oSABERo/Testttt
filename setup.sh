#!/bin/bash

# Update and install necessary packages
sudo apt update
sudo apt upgrade -y
sudo apt install -y $(cat installer/config/packages.txt)
sudo apt install python3 python3-pip python3-venv -y

# Create a virtual environment
rm -rf venv
python3 -m venv venv

# Activate the virtual environment
source venv/bin/activate

# Install dependencies from requirements.txt
pip install -r requirements.txt

# Check if the necessary packages are installed
if ! pip freeze | grep -q 'Error'; then
    echo "Error: Failed to install"
    exit 1
fi

# Copy .service files to systemd directory
sudo rsync installer/config/backend.service /etc/systemd/system/
sudo rsync installer/config/data.service /etc/systemd/system/
sudo rsync installer/config/subbackend.service /etc/systemd/system/

# Reload systemd daemon and enable services
sudo systemctl daemon-reload
sudo systemctl enable backend.service
sudo systemctl enable data.service

# Start service
sudo systemctl start backend.service
sudo systemctl start data.service

# Get the current IP address of the VM
IP_ADDRESS=$(hostname -I | cut -d' ' -f1)

# Run Uvicorn server with the IP address of the VM
uvicorn apiii.main:app --reload --host $IP_ADDRESS --port 8080
