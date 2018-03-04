#!/bin/bash
#Purpose - This is a script to automate the process of installing a tf2server stack on a clean Debian or Ubuntu server instance. The script needs to be ran as root to function properly. Please auit the code below before running in your environment.

# Variables used in script. Only edit the STEAMID and STEAMUSERNAME variable.
export METAMODURL='https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git961-linux.tar.gz'
export METAMODFILENAME='mmsource-1.10.7-git961-linux.tar.gz'
export SOURCEMODURL='https://sm.alliedmods.net/smdrop/1.8/sourcemod-1.8.0-git6041-linux.tar.gz'
export SOURCEMODFILENAME='sourcemod-1.8.0-git6041-linux.tar.gz'
export STEAMID='PUT-STEAM-ID-HERE'
export STEAMUSERNAME='PUT-STEAM-USERNAME-HERE'
export DEFAULTMAP='pl_upward'
export PLAYERS='24'

# Check if root
if [ "$EUID" -ne 0 ]
  then echo "Run as root or use sudo."
  exit 1
fi

# Install sudo incase its not installed.
apt-get -y install sudo

# Update the server
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get autoclean

# Turn off ubuntu auto updates
sed 's/"1"/"0"/' /etc/apt/apt.conf.d/10periodic > tmp-file && mv tmp-file /etc/apt/apt.conf.d/10periodic
sed 's/"1"/"0"/' /etc/apt/apt.conf.d/20auto-upgrades > tmp-file && mv tmp-file /etc/apt/apt.conf.d/20auto-upgrades

# Install required packages and utilities used later in the script
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get -y install curl wget tmux lib32z1 lib32ncurses5 libbz2-1.0:i386 lib32gcc1 lib32stdc++6 libcurl3-gnutls:i386 libtinfo5:i386 libncurses5:i386

# Add user account
useradd -m -s /bin/bash tf2server
passwd tf2server

# Install tf2 server function
install-tf2-server() {
cd ~
wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
tar -zxf steamcmd_linux.tar.gz
rm steamcmd_linux.tar.gz

cat << EOT >> ~/tf2_ds.txt
login anonymous
force_install_dir ./tf2
app_update 232250 validate
quit
EOT

cat << EOT >> ~/update.sh
#!/bin/sh
./steamcmd.sh +runscript tf2_ds.txt
EOT

chmod +x ~/update.sh
~/update.sh

# Fix for srcds looking in wrong directory for binaries. (Such as steamclient.so)
ln -s ~/tf2/bin ~/.steam/sdk32

cat << EOT >> ~/tf2/tf/cfg/server.cfg
hostname "Your_Server's_Name"
rcon_password "Your_Rcon_Password"
sv_contact "admin@yourdomain.com"
mp_timelimit "30"
EOT

cat << EOT >> ~/tf.sh
#!/bin/sh
tmux new-session -d -s tf2server "~/tf2/srcds_run -autoupdate -ip 0.0.0.0 -steam_dir ~/ -steamcmd_script ~/tf2_ds.txt -console -game tf +sv_pure 1 +map $DEFAULTMAP +maxplayers $PLAYERS"
EOT

# Install MetaMod and SourceMod
cd ~/tf2/tf
wget $METAMODURL
tar -xf $METAMODFILENAME
rm $METAMODFILENAME

wget $SOURCEMODURL
tar -xf $SOURCEMODFILENAME
rm $SOURCEMODFILENAME

# Setup Steam id's for admin
cat << EOT >> /home/tf2server/tf2/tf/addons/sourcemod/configs/admins_simple.ini
"$STEAMID" "99:z" //$STEAMUSERNAME
EOT

chmod +x ~/tf.sh
~/tf.sh
}

# Export the function
export -f install-tf2-server

# Install the tf2server
su tf2server -c "bash -c install-tf2-server"

# Configure firewall
sudo apt-get -y install iptables iptables-persistent

# Wipe the v4 rules
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X

# Wipe the v6 rules
sudo ip6tables -P INPUT ACCEPT
sudo ip6tables -P FORWARD ACCEPT
sudo ip6tables -P OUTPUT ACCEPT
sudo ip6tables -t nat -F
sudo ip6tables -t mangle -F
sudo ip6tables -F
sudo ip6tables -X

# Set up rules
sudo iptables -I INPUT 1 -i lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp -m state --state NEW,ESTABLISHED --dport 22 -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -m state --state NEW,ESTABLISHED  -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -m state --state NEW,ESTABLISHED  -j ACCEPT
sudo iptables -A INPUT -p udp --dport 27015 -m state --state NEW,ESTABLISHED  -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 27015 -m state --state NEW,ESTABLISHED  -j ACCEPT
sudo iptables -A INPUT -p udp --dport 27020 -m state --state NEW,ESTABLISHED  -j ACCEPT
sudo iptables -P INPUT DROP

# Save the firewall rules
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6

# Setup web server
sudo apt-get -y install apache2
mkdir -p /var/www/html/fastdl/tf2/
cd /var/www/html/fastdl/tf2/
ln -s /home/tf2server/tf2/tf/maps maps
sudo systemctl start apache2.service
sudo systemctl enable apache2.service
mv /var/www/html/index.html /var/www/html/index.html.bak

# Add cronjobs
echo "@reboot         tf2server /home/tf2server/tf.sh" >> /etc/crontab

# Set a restart of the server for midnight.
sudo shutdown -r -t 0:00
