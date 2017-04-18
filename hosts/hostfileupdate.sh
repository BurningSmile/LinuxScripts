#!/bin/bash
#This script is ment to be ran by a cronjob. Please change USERNAMEHERE with your username.
cd /home/USERNAMEHERE/.scripts/hosts/
git pull #update repo
python3 updateHostsFile.py --auto --replace  --extensions porn gambling fakenews
