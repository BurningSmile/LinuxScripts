#!/bin/bash

#First setup, uncomment if needed
#mkdir ~/.scripts
#cd ~/.scripts
#git clone --depth 2 https://github.com/StevenBlack/hosts.git
#/bin/bash /home/usernamehere/.scripts/add-custom-hosts.sh

#If first setup is done just run this
cd /home/USERNAMEHERE/.scripts/hosts/
git pull #update repo
python3 updateHostsFile.py --auto --replace  --extensions porn gambling fakenews
