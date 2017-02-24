#!/bin/bash

# Get sudo for script run
sudo -v

#Backup .Xresources
sudo cp ~/.Xresources ~/.Xresources.bak

# Install required packages from main Repos
sudo pacman -S --needed i3 rofi feh lxappearance compton git wget unzip --noconfirm
yes | sudo pacman -S termite

#install i3blocks from AUR
cd ~/Downloads
wget https://aur.archlinux.org/cgit/aur.git/snapshot/i3blocks.tar.gz
tar -xvf i3blocks.tar.gz
cd i3blocks
makepkg -si --noconfirm

#install fonts for system
mkdir ~/.fonts
cd ~/Downloads
wget https://github.com/chrissimpkins/Hack/releases/download/v2.020/Hack-v2_020-ttf.zip
mkdir HackFont
unzip Hack-v2_020-ttf.zip -d HackFont
cd HackFont
cp Hack-Regular.ttf ~/.fonts

cd ~/Downloads
wget https://github.com/FortAwesome/Font-Awesome/archive/v4.7.0.tar.gz
tar -xvzf v4.7.0.tar.gz
cd  'Font-Awesome-4.7.0/fonts'
cp fontawesome-webfont.ttf ~/.fonts

#Clean up Downloads folder
cd ~/Downloads
rm -rf Font-Awesome-4.7.0 HackFont i3blocks
rm Hack-v2_020-ttf.zip  v4.7.0.tar.gz i3blocks.tar.gz

#Download config files from GitHub
cd ~
git clone https://github.com/BurningSmile/dotfiles.git
cd ~/dotfiles/

#Install configs
cd ~/dotfiles/Termite_Terminal
sudo mkdir ~/.config/termite
sudo cp config ~/.config/termite
cd ~/dotfiles/i3
mkdir ~/.config/i3
cp config ~/.config/i3/
cp i3blocks.conf ~/.config/i3/
cp -r scripts ~/.config/i3
cd ~/dotfiles/
cp .Xresources ~

#Copy background image
cp ~/dotfiles/i3/Background/wallpaperArch.png ~/Pictures

cd ~
rm -rf dotfiles/
#Echo when complete
echo "Install is finished. Restart Arch Linux to log into i3."
