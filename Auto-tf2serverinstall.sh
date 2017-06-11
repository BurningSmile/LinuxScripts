#!/bin/bash
#Purpose - This is a script to automate the process of installing a tf2server stack on a clean ubuntu 16.04.2 LTS server instance. The script needs to be ran as root to function properly. Please auit the code below before running in your envoirment.
#Written on 06-05-2017
#Written by Burning-Smile
#last modified -6-05-2017

#Variables used in script. Only edit the STEAMID variable.
METAMODURL='https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git957-linux.tar.gz'
METAMODFILENAME='mmsource-1.10.7-git957-linux.tar.gz'
SOURCEMODURL='https://sm.alliedmods.net/smdrop/1.8/sourcemod-1.8.0-git6002-linux.tar.gz'
SOURCEMODFILENAME='sourcemod-1.8.0-git6002-linux.tar.gz'
STEAMID='PUT-STEAM-ID-HERE'
USERNAME='PUT-USERNAME-HERE'

#Get sudo rights just in case
sudo -v

#Update the server
apt update
apt upgrade -y
apt dist-upgrade -y
apt autoremove -y
apt clean

#Turn off auto updates
sed 's/"1"/"0"/' /etc/apt/apt.conf.d/10periodic > tmp-file && mv tmp-file /etc/apt/apt.conf.d/10periodic

#Install dependices for the tf2server instance
sudo dpkg --add-architecture i386; sudo apt-get update;sudo apt-get install binutils mailutils postfix curl wget file bzip2 gzip unzip bsdmainutils python util-linux ca-certificates tmux lib32gcc1 libstdc++6 libstdc++6:i386 libcurl4-gnutls-dev:i386 -y

adduser tf2server
passwd tf2server

su - tf2server -c 'wget https://gameservermanagers.com/dl/tf2server'
su - tf2server -c 'chmod +x /home/tf2server/tf2server'
su - tf2server -c '/home/tf2server/tf2server auto-install'
su - tf2server -c 'vim /home/tf2server/tf2server'
su - tf2server -c '/home/tf2server/tf2server start'

# Allow 27015 and 27020 through the firewall
ufw allow 27015
ufw allow 27020

#Setup web server
apt install apache2 -y
mkdir -p /var/www/html/fastdl/tf2/
cd /var/www/html/fastdl/tf2/
ln -s /home/tf2server/serverfiles/tf/maps maps
systemctl start apache2.service
systemctl enable apache2.service 
mv /var/www/html/index.html /var/www/html/index.html.bak

#Setup metamod and sourcemod
cat <<EOF>> /home/tf2server/source-metamodinstall.sh
cd /home/tf2server/serverfiles/tf
wget $METAMODURL
tar -xvf $METAMODFILENAME
rm $METAMODFILENAME

wget $SOURCEMODURL
tar -xvf $SOURCEMODFILENAME
rm $SOURCEMODFILENAME
EOF

chown tf2server:tf2server /home/tf2server/source-metamodinstall.sh
chmod +x /home/tf2server/source-metamodinstall.sh
su - tf2server -c '/home/tf2server/source-metamodinstall.sh'
su - tf2server -c 'rm /home/tf2server/source-metamodinstall.sh'

#Setup Steam id's for admin
cat <<EOF >> /home/tf2server/steamid.sh

cat <<EOL >> /home/tf2server/serverfiles/tf/addons/sourcemod/configs/admins_simple.ini
"$STEAMID" "99:z" //$USERNAME
EOL

EOF

chmod +x /home/tf2server/steamid.sh
su - tf2server -c '/home/tf2server/steamid.sh'

#CFG.tf
#This needs to be worked on, placeholder until I can find a way to automate this

#Cronjobs
#Will be added once I can get this working properly. Currently it seems it has to be done manually.
