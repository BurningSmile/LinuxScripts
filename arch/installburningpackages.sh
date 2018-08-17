#!/bin/bash

# Get sudo permissions for script run
sudo -v

# Update system packages
sudo pacman -Syu --noconfirm

# Install git and wget if necessary
sudo pacman -S --needed git wget --noconfirm

# Install aura
sudo pacman -S --needed base-devel gmp pcre --noconfirm

cd /tmp/
wget https://aur.archlinux.org/cgit/aur.git/snapshot/aura-bin.tar.gz
tar -xzf aura-bin.tar.gz
cd aura-bin
makepkg -si --noconfirm

# Update aur packages
sudo aura -Aau --noconfirm

# Install numix-curser-theme
sudo aura -Aa numix-cursor-theme-git --noconfirm

# Backup .Xresources
sudo cp ~/.Xresources ~/.Xresources.bak

# Install required packages from main Repos
sudo pacman -S --needed compton dunst feh i3 i3lock jsoncpp libmpdclient lxappearance rofi unzip xautolock --noconfirm

# Install polybar from AUR
sudo aura -Aa polybar-git --noconfirm

# Install fonts for system
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

# Reload font cache
fc-cache -f -v

# Download config files from GitHub
cd ~
git clone https://github.com/BurningSmile/dotfiles.git

# Install configs
cd ~/dotfiles/
mkdir ~/.config/polybar/
mv ./polybar/* ~/.config/polybar/
mkdir ~/.config/i3
mv ./i3/config ~/.config/i3/
mv ./i3/scripts ~/.config/i3
mv .Xresources ~
mkdir ~/.config/dunst
mv ./dunst/dunstrc ~/.config/dunst/dunstrc
mkdir ~/.config/rofi
mv ./rofi/* ~/.config/rofi/

# Copy background image
mkdir ~/Pictures/backgrounds
mv ~/dotfiles/i3/Background/firewatch_ARC.jpg ~/Pictures/backgrounds

# Install vim
sudo pacman -S --needed  gvim  --noconfirm
sudo aura -Aa vim-plug-git --noconfirm
cd ~/dotfiles/vim
mkdir ~/.vim/
mv ~/.vimrc ~/.vimrc.bak # Backup vimrc if present
mv .vimrc ~
cp -r ./.vim/ultisnips ~/.vim/
cd ~

# Install vim plugins
vim +PlugClean +PlugInstall +PlugUpdate +q! +q!

# Install you-complete-me for vim auto completion.
sudo pacman -S --needed cmake clang python python3 --noconfirm
mkdir /tmp/ycm_build
cd /tmp/ycm_build
cmake -G "Unix Makefiles" . ~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp
cmake -G "Unix Makefiles" -DUSE_SYSTEM_LIBCLANG=ON . ~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp
cmake --build . --target ycm_core --config Release
cd ~

# Install powerline
sudo pacman -S --needed powerline powerline-fonts powerline-vim --noconfirm

# Install tmux
sudo pacman -S --needed tmux xclip xsel --noconfirm
sudo aura -Aa tmux-bash-completition --noconfirm
cd ~/dotfiles/tmux
mv ~/.tmux.conf ~/.tmux.conf.bak # Backup Tmux.conf if present.
mv .tmux.conf ~
mv ~/dotfiles/tmux/.tmux-ssh.conf ~
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cd ~

# Install theme
sudo pacman -S --needed arc-gtk-theme --noconfirm

# Install htop
sudo pacman -S htop --noconfirm
mv ~/.config/htop/htoprc ~/.config/htop/htoprc.bak # Backup htoprc if present
cd ~/dotfiles/htop
mkdir ~/.config/htop
mv htoprc ~/.config/htop/
cd ~

# Setup Mpd and Mpc
sudo pacman -S mpd mpc --noconfirm
mkdir -p ~/.config/mpd/
mkdir -p ~/.mpd/playlists
cd ~/.mpd/
touch database log pid state sticker.sql
mv ~/.config/mpd/mpd.conf ~/.config/mpd/mpd.conf.bak #Backup config if present
mv ~/dotfiles/mpd/mpd.conf ~/.config/mpd/
sudo systemctl disable mpd.service

# Setup Ncmpcpp
sudo pacman -S ncmpcpp --noconfirm
mkdir ~/.ncmpcpp/
mv ~/.ncmpcpp/config ~/.ncmpcpp/config.bak #Backup config if present
mv ~/dotfiles/ncmpcpp/config ~/.ncmpcpp/
cd ~

# Setup Cava
sudo aura -Aa cava --noconfirm
mkdir ~/.config/cava
mv ~/.config/cava/config ~/.config/cava/config.bak #Backup config if present
mv ~/dotfiles/cava/config ~/.config/cava

# Setup urxvt
sudo pacman -S rxvt-unicode --noconfirm
sudo aura -Aa urxvt-vtwheel urxvt-fullscreen --noconfirm

# Install zsh
sudo pacman -S zsh --noconfirm

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)" -s --batch
mv ~/dotfiles/zsh/.zshrc ~/.zshrc

# Cleanup
cd ~
rm -rf dotfiles/
