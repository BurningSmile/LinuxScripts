#Please don't use this script right now. It is under work and will not work with my current dotfiles!

#!/bin/bash

# Get sudo for script run
sudo -v

#install system updates & remove old packages
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt clean
sudo apt autoremove -y

#Backup .Xresources
sudo cp ~/.Xresources ~/.Xresources.bak

#Install i3 
sudo apt install i3 rofi feh lxappearance compton git wget unzip i3blocks -y

#install fonts for system
mkdir ~/.fonts
cd /tmp
wget https://github.com/chrissimpkins/Hack/releases/download/v2.020/Hack-v2_020-ttf.zip
mkdir HackFont
unzip Hack-v2_020-ttf.zip -d HackFont
cd HackFont
cp Hack-Regular.ttf ~/.fonts

cd /tmp
wget https://github.com/FortAwesome/Font-Awesome/archive/v4.7.0.tar.gz
tar -xvzf v4.7.0.tar.gz
cd  'Font-Awesome-4.7.0/fonts'
cp fontawesome-webfont.ttf ~/.fonts

cd /tmp
git clone https://github.com/BurningSmile/dotfiles.git

cd /tmp/dotfiles/Ubuntu-i3/
mkdir ~/.config/i3
cp config ~/.config/i3/
cd /tmp/dotfiles/i3
cp i3blocks.conf ~/.config/i3/
cp -r scripts ~/.config/i3
cd /tmp/dotfiles
cp .Xresources ~

#Copy background image
cp /tmp/dotfiles/i3/Background/wallpaperArch.png ~/Pictures

cd ~
echo "Install is finished. Restart Ubuntu Linux to log into i3."
