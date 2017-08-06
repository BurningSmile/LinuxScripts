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
tar -xzf cower.tar.gz
cd cower
makepkg -si --noconfirm

cd /tmp/
wget https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
tar -xzf pacaur.tar.gz
cd pacaur
makepkg -si --noconfirm

#update aur packages
pacaur -Syua --noconfirm --noedit

#install numix-curser-theme
pacaur -Sa numix-cursor-theme-git --noconfirm --noedit

#backup .Xresources
sudo cp ~/.Xresources ~/.Xresources.bak

#install required packages from main Repos
sudo pacman -S --needed compton dunst feh i3 jsoncpp libmpdclient lxappearance rofi unzip --noconfirm

#install polybar from AUR
pacaur -Sa polybar-git --noconfirm --noedit

#install fonts for system
mkdir ~/.fonts
cd /tmp/
wget https://github.com/chrissimpkins/Hack/releases/download/v2.020/Hack-v2_020-ttf.zip
mkdir HackFont
unzip Hack-v2_020-ttf.zip -d HackFont
cd HackFont
cp Hack-Regular.ttf ~/.fonts

cd /tmp/
wget https://github.com/FortAwesome/Font-Awesome/archive/v4.7.0.tar.gz
tar -xzf v4.7.0.tar.gz
cd 'Font-Awesome-4.7.0/fonts'
cp fontawesome-webfont.ttf ~/.fonts

#reload font cache
fc-cache -f -v

#install i3-lock-fancy
pacaur -S i3lock-fancy-git --noconfirm --noedit
cd /tmp/
git clone https://github.com/meskarune/i3lock-fancy.git
cd i3lock-fancy
sudo mv icons/ /usr/local/bin
sudo mv lock /usr/local/bin

#download config files from GitHub
cd ~
git clone https://github.com/BurningSmile/dotfiles.git

#install configs
cd ~/dotfiles/
mkdir ~/.config/polybar/
mv ./polybar/* ~/.config/polybar/
mkdir ~/.config/i3
mv ./i3/config ~/.config/i3/
mv ./i3/scripts ~/.config/i3
mv .Xresources ~
mv ./zsh/.zshrc ~/.zshrc.bak
mkdir ~/.config/dunst
mv ./dunst/dunstrc ~/dunstrc

#copy background image
mkdir ~/Pictures/backgrounds
mv ~/dotfiles/i3/Background/Mountins-Wallpaper.jpg ~/Pictures/backgrounds
mv ~/dotfiles/i3/Background/firewatch_ARC.jpg ~/Pictures/backgrounds

#install vim
sudo pacman -S --needed  gvim  --noconfirm
pacaur -S vim-plug-git --noconfirm --noedit
cd ~/dotfiles/vim
mkdir ~/.vim/
cp -r .vim/. ~/.vim/
mv ~/vimrc ~/vimrc.bak # Backup vimrc if present
mv .vimrc ~
cd ~

#install vim plugins
vim +PlugClean +PlugInstall +PlugUpdate +q! +q!

#install you-complete-me for vim auto completion.
sudo pacman -S --needed cmake clang python python3 --noconfirm
mkdir /tmp/ycm_build
cd /tmp/ycm_build
cmake -G "Unix Makefiles" . ~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp
cmake -G "Unix Makefiles" -DUSE_SYSTEM_LIBCLANG=ON . ~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp
cmake --build . --target ycm_core --config Release
cd ~

#Install vim-instant-markdown
sudo pacman -S --needed nodejs xdg-utils curl --noconfirm
sudo npm -g install instant-markdown-d

#install powerline
sudo pacman -S --needed powerline powerline-fonts powerline-vim --noconfirm

#install tmux
sudo pacman -S --needed tmux xclip xsel --noconfirm
pacaur -S tmux-bash-completition --noconfirm --noedit
cd ~/dotfiles/tmux
mv ~/.tmux.conf ~/.tmux.conf.bak # Backup Tmux.conf if present.
mv .tmux.conf ~
mv ~/dotfiles/tmux/.tmux ~
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cd ~

#install theme
sudo pacman -S --needed arc-gtk-theme --noconfirm

#install htop
sudo pacman -S htop --noconfirm
mv ~/.config/htop/htoprc ~/.config/htop/htoprc.bak # Backup htoprc if present
cd ~/dotfiles/htop
mkdir ~/.config/htop
mv htoprc ~/.config/htop/
cd ~

#setup mpd and mpc
sudo pacman -S mpd mpc --noconfirm
mkdir -p ~/.config/mpd/
mkdir -p ~/.mpd/playlists
cd ~/.mpd/
touch database log pid state sticker.sql
mv ~/.config/mpd/mpd.conf ~/.config/mpd/mpd.conf.bak #Backup config if present
mv ~/dotfiles/mpd/mpd.conf ~/.config/mpd/

#setup ncmpcpp
sudo pacman -S ncmpcpp --noconfirm
mkdir ~/.ncmpcpp/
mv ~/.ncmpcpp/config ~/.ncmpcpp/config.bak #Backup config if present
mv ~/dotfiles/ncmpcpp/config ~/.ncmpcpp/
cd ~

# setup Cava
pacaur -S cava --noedit --noconfirm
mkdir ~/.config/cava
mv ~/.config/cava/config ~/.config/cava/config.bak #Backup config if present
mv ~/dotfiles/cava/config ~/.config/cava

#setup urxvt
sudo pacman -S rxvt-unicode --noconfirm
pacaur -S urxvt-vtwheel urxvt-fullscreen --noedit --noconfirm

#remove LinuxConfigs folder
cd ~
rm -rf dotfiles/

#install the Fuck
sudo pacman -S thefuck --noconfirm

#install zshell
sudo pacman -S zsh --noconfirm

#install ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
