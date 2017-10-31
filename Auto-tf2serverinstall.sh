#!/bin/bash
#Purpose - This is a script to automate the process of installing a tf2server stack on a clean Debian or Ubuntu server instance. The script needs to be ran as root to function properly. Please auit the code below before running in your envoirment.
#Written on 06-05-2017
#Written by Burning-Smile
#last modified 08-12-2017

#Variables used in script. Only edit the STEAMID and STEAMUSERNAME variable.
METAMODURL='https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git959-linux.tar.gz'
METAMODFILENAME='mmsource-1.10.7-git959-linux.tar.gz'
SOURCEMODURL='https://sm.alliedmods.net/smdrop/1.8/sourcemod-1.8.0-git6035-linux.tar.gz'
SOURCEMODFILENAME='sourcemod-1.8.0-git6035-linux.tar.gz'
STEAMID='PUT-STEAM-ID-HERE'
STEAMUSERNAME='PUT-Steam-USERNAME-HERE'

#Install sudo incase its not installed.
apt install sudo

#Get sudo rights just in case
sudo -v

#Update the server
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt clean

# Turn off ubuntu auto updates
sed 's/"1"/"0"/' /etc/apt/apt.conf.d/10periodic > tmp-file && mv tmp-file /etc/apt/apt.conf.d/10periodic
sed 's/"1"/"0"/' /etc/apt/apt.conf.d/20auto-upgrades > tmp-file && mv tmp-file /etc/apt/apt.conf.d/20auto-upgrades

# Install dependices for the tf2server instance
sudo dpkg --add-architecture i386; sudo apt-get update; sudo apt-get install mailutils postfix curl wget file bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc tmux lib32gcc1 libstdc++6 libstdc++6:i386 libcurl4-gnutls-dev:i386 libtcmalloc-minimal4:i386 -y

# Add user account
useradd -m --password default -s /bin/bash tf2server
passwd tf2server

# Get the framework script and install the server.
su - tf2server -c 'wget -N --no-check-certificate https://gameservermanagers.com/dl/linuxgsm.sh && chmod +x linuxgsm.sh && bash linuxgsm.sh tf2server'
su - tf2server -c '/home/tf2server/tf2server auto-install'
su - tf2server -c 'echo 'defaultmap="cp_badlands"' > /home/tf2server/lgsm/config-lgsm/tf2server/tf2server.cfg'
su - tf2server -c 'echo 'maxplayers="16"' >> /home/tf2server/lgsm/config-lgsm/tf2server/tf2server.cfg'
su - tf2server -c 'echo 'updateonstart="on"' >> /home/tf2server/lgsm/config-lgsm/tf2server/tf2server.cfg'
su - tf2server -c 'vim /home/tf2server/lgsm/config-lgsm/tf2server/tf2server.cfg'
su - tf2server -c '/home/tf2server/tf2server start'

# Allow 27015 and 27020 through the firewall
sudo apt install ufw
ufw allow 27015
ufw allow 27020

# Setup web server
sudo apt install apache2 -y
mkdir -p /var/www/html/fastdl/tf2/
cd /var/www/html/fastdl/tf2/
ln -s /home/tf2server/serverfiles/tf/maps maps
sudo systemctl start apache2.service
sudo systemctl enable apache2.service
mv /var/www/html/index.html /var/www/html/index.html.bak

# Setup metamod and sourcemod
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

# Setup Steam id's for admin
cat <<EOF >> /home/tf2server/steamid.sh

cat <<EOL >> /home/tf2server/serverfiles/tf/addons/sourcemod/configs/admins_simple.ini
"$STEAMID" "99:z" //$STEAMUSERNAME
EOL

EOF

chmod +x /home/tf2server/steamid.sh
su - tf2server -c '/home/tf2server/steamid.sh'
su - tf2server -c 'rm -f /home/tf2server/steamid.sh'

su - tf2server -c '/home/tf2server/tf2server restart'

#CFG.tf
#This needs to be worked on, placeholder until I can find a way to automate this

# Add cronjobs
su - tf2server -c 'crontab -l | { cat; echo "0 0 * * * /home/tf2server/tf2server restart"; } | crontab -'
su - tf2server -c 'crontab -l | { cat; echo "@reboot /home/tf2server/tf2server start"; } | crontab -'

#Set a restart of the server for midnight incase it is not done manually.
sudo shutdown -r -t 0:00
