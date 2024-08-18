#!/bin/bash

# check
if [ "$EUID" -ne 0 ]; then
    echo "Error: Failed to install"
    exit 1
fi

# Update and installcpackages
apt update
apt install -y $(cat installer/config/packages.txt)

# Createcenvironment
rm -rf venv #todo
python3 -m venv venv #change name venv

# Activatecnvironment
source venv/bin/activate

# Installcrequirements.txt
pip install -r requirements.txt

rsync installer/config/backend.service /etc/systemd/system/
# sudo rsync installer/config/data.service /etc/systemd/system/ 
# sudo rsync installer/config/subbackend.service /etc/systemd/system/ 

# Reload and enable services
#sudo systemctl daemon-reload
# sudo systemctl enable data.service
systemctl enable backend.service

# reStart service
# sudo systemctl restart data.service
systemctl restart backend.service

