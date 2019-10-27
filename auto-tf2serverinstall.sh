#!/bin/bash
#Purpose - This is a script to automate the process of installing a tf2server stack on a clean Debian or Ubuntu server instance. The script needs to be ran as root to function properly. Please audit the code below before running in your environment.
# Usage: Call the script with ./auto-tf2serverinstall.sh <tf2-user-pass>

# Variables used in script.
export METAMODURL='https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git961-linux.tar.gz'
export METAMODFILENAME='mmsource-1.10.7-git961-linux.tar.gz'
export SOURCEMODURL='https://sm.alliedmods.net/smdrop/1.8/sourcemod-1.8.0-git6041-linux.tar.gz'
export SOURCEMODFILENAME='sourcemod-1.8.0-git6041-linux.tar.gz'
export STEAMID='PUT-STEAM-ID-HERE'
export STEAMUSERNAME='PUT-STEAM-USERNAME-HERE'
export DEFAULTMAP='pl_upward'
export PLAYERS='24'
export PASSWORD="$1"

# Set script basename
SCRIPT=`basename ${BASH_SOURCE[0]}`

# Usage function
usage() {
    echo "Call this script with $SCRIPT <tf2-user-pass>"
    echo "Example: $SCRIPT fjlafjlajf13@"
    exit 1
}

# Check for required inputs
if [ "$#" -ne 1 ]; then
    usage
fi

# Check if running with sudo/root privileges
if [ "$EUID" -ne 0 ]
then
  echo "Run as root or use sudo."
  exit 1
fi

# Check for required variables

# Check for sudo and install if not found in $path.
which sudo > /dev/null || apt-get -y install sudo

# Prompt for sudo rights
sudo -v

# Update the server
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get autoclean

# Install dependencies for the tf2server instance
sudo dpkg --add-architecture i386; sudo apt update; sudo apt install mailutils curl wget file tar bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc jq tmux lib32gcc1 libstdc++6 libstdc++6:i386 libcurl4-gnutls-dev:i386 libtcmalloc-minimal4:i386

# Add user account
useradd -m -s /bin/bash tf2server
echo "tf2server:$PASSWORD" | chpasswd

# Get the framework script and install the server.
su - tf2server -c 'wget -N --no-check-certificate https://linuxgsm.com/dl/linuxgsm.sh && chmod +x linuxgsm.sh && /bin/bash linuxgsm.sh tf2server'
su - tf2server -c '/home/tf2server/tf2server auto-install'
su - tf2server -c "echo "defaultmap=\"$DEFAULTMAP\"" > /home/tf2server/lgsm/config-lgsm/tf2server/tf2server.cfg"
su - tf2server -c "echo "maxplayers=\"$PLAYERS\"" >> /home/tf2server/lgsm/config-lgsm/tf2server/tf2server.cfg"
su - tf2server -c "echo 'updateonstart="on"' >> /home/tf2server/lgsm/config-lgsm/tf2server/tf2server.cfg"

# Install iptables
sudo apt-get install -y iptables iptables-persistent

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

# Configure ipv4 firewall
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

# Configure ipv6 firewall
sudo ip6tables -P INPUT DROP
sudo ip6tables -P FORWARD DROP
sudo ip6tables -P OUTPUT ACCEPT
sudo ip6tables -A INPUT -i lo -j ACCEPT
sudo ip6tables -A INPUT -p tcp --syn -j DROP
sudo ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo ip6tables -A INPUT -p ipv6-icmp -j ACCEPT
sudo ip6tables -A INPUT -m state --state NEW -m udp -p udp -s fe80::/10 --dport 546 -j ACCEPT
sudo ip6tables -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
sudo ip6tables -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
sudo ip6tables -A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT

# Save the firewall rules
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6

# Setup web server
sudo apt-get install -y apache2
mkdir -p /var/www/html/fastdl/tf2/
cd /var/www/html/fastdl/tf2/
ln -s /home/tf2server/serverfiles/tf/maps maps
sudo systemctl start apache2.service
sudo systemctl enable apache2.service
mv /var/www/html/index.html /var/www/html/index.html.bak

# Setup metamod and sourcemod
install-metamod () {
cd /home/tf2server/serverfiles/tf
wget $METAMODURL
tar -xf $METAMODFILENAME
rm $METAMODFILENAME

wget $SOURCEMODURL
tar -xf $SOURCEMODFILENAME
rm $SOURCEMODFILENAME
}

export -f install-metamod
su tf2server -c "bash -c install-metamod"

# Setup Steam id's for admin
configure-sourcemod-admins () {
cat <<EOL >> /home/tf2server/serverfiles/tf/addons/sourcemod/configs/admins_simple.ini
"$STEAMID" "99:z" //$STEAMUSERNAME
EOL
}

export -f configure-sourcemod-admins
su tf2server -c "bash -c configure-sourcemod-admins"

# Start the tf2server
su - tf2server -c '/home/tf2server/tf2server start'

# Add cronjobs
echo "@reboot         tf2server /home/tf2server/tf2server start" >> /etc/crontab
echo "0 0     * * *   tf2server /home/tf2server/tf2server restart" >> /etc/crontab

# Set a one time restart of the server for midnight.
sudo shutdown -r -t 0:00
