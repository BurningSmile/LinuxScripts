#!/bin/bash
cd /tmp/
git clone https://github.com/BurningSmile/LinuxScripts.git
mkdir -p ~/.scripts/
cd ~/.scripts
git clone --depth 2 https://github.com/StevenBlack/hosts.git
cd ~/.scripts/hosts
cp /tmp/LinuxScripts/hosts/add-custom-hosts.sh ~/.scripts/hosts
/bin/bash ~/.scripts/hosts/add-custom-hosts.sh
python3 updateHostsFile.py --auto --replace  --extensions porn gambling fakenews
