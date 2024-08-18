#!/bin/bash

# Update and installcpackages
sudo apt update
sudo apt upgrade -y
sudo apt install -y $(cat installer/config/packages.txt)
sudo apt install python3 python3-pip python3-venv -y

# Createcenvironment
rm -rf venv
python3 -m venv venv

# Activatecnvironment
source venv/bin/activate

# Installcrequirements.txt
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "Error: Failed to install"
    exit 1
fi

sudo rsync installer/config/backend.service /etc/systemd/system/
sudo rsync installer/config/data.service /etc/systemd/system/
sudo rsync installer/config/subbackend.service /etc/systemd/system/

# Reload and enable services
#sudo systemctl daemon-reload
sudo systemctl enable data.service
sudo systemctl enable backend.service

# Start service
sudo systemctl start data.service
sudo systemctl start backend.service

# Show Status 
sudo systemctl status data.service
