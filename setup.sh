#!/bin/bash

# Update and install necessary packages
sudo apt update
sudo apt upgrade -y
sudo apt install -y $(cat /Testttt/installer/config/packages.txt)
sudo apt install python3 python3-pip python3-venv -y

# Create a virtual environment
rm -rf venv
python3 -m venv venv

# Install dependencies from requirements.txt
source venv/bin/activate
/Testttt -m pip install -r /Testttt/requirements.txt


# Check if the necessary packages are installed
if ! pip freeze | grep -q 'Error'; then
    echo "Error: Failed to install"
    exit 1
fi

# Copy .service files to systemd directory
sudo rsync /Testttt/installer/config/backend.service /etc/systemd/system/
sudo rsync /Testttt/installer/config/data.service /etc/systemd/system/

# Reload systemd daemon and enable services
sudo systemctl daemon-reload
sudo systemctl enable backend.service
sudo systemctl enable data.service

# Start service
sudo systemctl start backend.service
sudo systemctl start data.service

# Check service status
sudo systemctl status backend.service
sudo systemctl status data.service
