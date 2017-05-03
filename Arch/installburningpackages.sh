#!/bin/bash

# Get sudo permissions for script run
sudo -v

#update system packages
sudo pacman -Syu --noconfirm

#install git and wget if necessary
sudo pacman -S --needed git wget --noconfirm

#install pacaur
sudo pacman -S --needed base-devel --noconfirm

cd /tmp/
sudo pacman -S --needed curl openssl yajl perl expac --noconfirm
gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
wget https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz
tar -xvf cower.tar.gz
cd cower
makepkg -si --noconfirm

cd /tmp/
wget https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
tar -xvf pacaur.tar.gz
cd pacaur
makepkg -si --noconfirm

#update aur packages
pacaur -Syua --noconfirm --noedit

#Install numix-curser-theme
pacaur -Sa numix-cursor-theme-git --noconfirm --noedit

#Backup .Xresources
sudo cp ~/.Xresources ~/.Xresources.bak

# Install required packages from main Repos
sudo pacman -S --needed i3 rofi feh lxappearance compton unzip --noconfirm
yes | sudo pacman -S termite

#install polybar from AUR
pacaur -Sa polybar --noconfirm --noedit
sudo pacman -S jsoncpp --noconfirm

#Install fonts for system
mkdir ~/.fonts
cd /tmp/
wget https://github.com/chrissimpkins/Hack/releases/download/v2.020/Hack-v2_020-ttf.zip
mkdir HackFont
unzip Hack-v2_020-ttf.zip -d HackFont
cd HackFont
cp Hack-Regular.ttf ~/.fonts

cd /tmp/
wget https://github.com/FortAwesome/Font-Awesome/archive/v4.7.0.tar.gz
tar -xvzf v4.7.0.tar.gz
cd 'Font-Awesome-4.7.0/fonts'
cp fontawesome-webfont.ttf ~/.fonts

#Reload font cache
fc-cache -f -v

#Install i3-lock-fancy
pacaur -S i3lock-fancy-git --noconfirm --noedit
cd /tmp/
git clone https://github.com/meskarune/i3lock-fancy.git
cd i3lock-fancy
sudo mv icons/ /usr/local/bin
sudo mv lock /usr/local/bin

#Download config files from GitHub
cd ~
git clone https://github.com/BurningSmile/dotfiles.git

#Install configs
cd ~/dotfiles/
mkdir ~/.config/termite
mv ./Termite_Terminal/config ~/.config/termite/
mkdir ~/.config/polybar/
mv ./polybar/config ~/.config/polybar/
mv ./polybar/launch.sh ~/.config/polybar/
mv ./polybar/redshift.sh ~/.config/polybar/
mkdir ~/.config/i3
mv ./i3/config ~/.config/i3/
cd ~/dotfiles/
mv .Xresources ~

#Copy background image
mv ~/dotfiles/i3/Background/wallpaperArch.png ~/Pictures

#install vim
sudo pacman -S vim  --noconfirm
pacaur -S vim-plug-git --noconfirm --noedit
cd ~/dotfiles/vim
mkdir ~/.vim/
cp -r .vim/* ~/.vim/
mv ~/vimrc ~/vimrc.bak # Backup vimrc if present
mv .vimrc ~

#install tmux
sudo pacman -S tmux xsel --noconfirm # xsel is for x copy support
pacaur -S tmux-bash-completition --noconfirm --noedit
cd ~/dotfiles/tmux
mv ~/.tmux.conf ~/.tmux.conf.bak # Backup Tmux.conf if present.
mv .tmux.conf ~

#install themes
cd ~/dotfiles/.themes
mkdir ~/.themes 
cp -r Numix/ ~/.themes/
cp -r oomox-numix/ ~/.themes/

#Install htop
sudo pacman -S htop --noconfirm
mv ~/.config/htop/htoprc ~/.config/htop/htoprc.bak # Backup htoprc if present
cd ~/dotfiles/htop
mkdir ~/.config/htop .
mv htoprc ~/.config/htop/

#Remove LinuxConfigs folder 
cd ~
rm -rf dotfiles/

#install the Fuck
sudo pacman -S thefuck --noconfirm

#install zshell
sudo pacman -S zsh --noconfirm

# install ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
