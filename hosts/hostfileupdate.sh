#!/bin/bash
#This script is to be ran by a cronjob by root. Please change USERNAMEHERE with your username.
cd /home/USERNAMEHERE/scripts/hosts/
git stash save --keep-index
git pull #update repo
python3 updateHostsFile.py --auto --replace  --extensions porn gambling fakenews
