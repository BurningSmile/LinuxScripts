#!/bin/bash

# Get sudo permissions for script run
sudo -v

#install git and wget if necessary
sudo pacman -S --needed git wget --noconfirm

#install pacaur
sudo pacman -S --needed base-devel --noconfirm

cd ~/Downloads
sudo pacman -S --needed curl openssl yajl perl expac --noconfirm
gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
wget https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz
tar -xvf cower.tar.gz
cd cower
makepkg -si --noconfirm

cd ~/Downloads
wget https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
tar -xvf pacaur.tar.gz
cd pacaur
makepkg -si --noconfirm

# Start of install i3

#Backup .Xresources
sudo cp ~/.Xresources ~/.Xresources.bak

# Install required packages from main Repos
sudo pacman -S --needed i3 rofi feh lxappearance compton git wget unzip --noconfirm
yes | sudo pacman -S termite

#install i3blocks from AUR
pacaur -Sa i3blocks --noconfirm --noedit

#Install fonts for system
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
rm -rf Font-Awesome-4.7.0 HackFont
rm Hack-v2_020-ttf.zip  v4.7.0.tar.gz

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

#End of install i3

#Remove LinuxConfigs folder 
cd ~
rm -rf dotfiles/

#install zshell
sudo pacman -S zsh --noconfirm

# install ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
