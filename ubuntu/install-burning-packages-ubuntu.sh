#/bin/bash

POLYBARURL=https://github.com/polybar/polybar/releases/download/3.4.2/polybar-3.4.2.tar
POLYBARNAME=polybar-3.4.2.tar

# Get sudo permissions for script run
sudo -v

# Update system
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get autoclean

# Install i3 and other packages
sudo apt-get -y install curl compton dunst feh i3 i3lock libjsoncpp1 libmpdclient2 lxappearance rofi git wget unzip xautolock

# Backup .Xresources
sudo cp ~/.Xresources ~/.Xresources.bak

# Install polybar
sudo apt-get -y install build-essential git cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libasound2-dev libmpdclient-dev libnl-genl-3-dev
cd /tmp
wget $POLYBARURL
tar -xf $POLYBARNAME
cd polybar
mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install
cd ~

# Istall fonts for system
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

# Install Vim
sudo apt-get -y install vim-gtk3
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cd ~/dotfiles/vim
mkdir ~/.vim/
mv ~/vimrc ~/vimrc.bak # Backup vimrc if present
mv .vimrc ~
cp -r ./.vim/ultisnips ~/.vim/
cd ~

# Install Vim plugins
vim +PlugClean +PlugInstall +PlugUpdate +q! +q!

# Install you-complete-me for vim auto completion.
sudo apt-get -y install build-essential cmake python3-dev
cd ~/.vim/plugged/YouCompleteMe/
python3 install.py --clang-completer

# Install powerline
sudo apt-get -y install python3-pip powerline fonts-powerline

# Install tmux
sudo apt-get -y install tmux xclip xsel # xsel is for x copy support
cd ~/dotfiles/tmux
mv ~/.tmux.conf ~/.tmux.conf.bak # Backup Tmux.conf if present.
mv .tmux.conf ~
mv ~/dotfiles/tmux/.tmux-ssh.conf ~
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cd ~

# Install Arc theme [This works for 16.10 and debian 9 and newer. For older versions refer to the arc theme documentation.]
sudo apt-get -y install arc-theme

# Install htop
sudo apt-get -y install htop
mv ~/.config/htop/htoprc ~/.config/htop/htoprc.bak # Backup htoprc if present
cd ~/dotfiles/htop
mkdir ~/.config/htop
mv htoprc ~/.config/htop/
cd ~

# Setup Mpd and Mpc
sudo apt-get -y install mpd mpc
mkdir -p ~/.config/mpd/
mkdir -p ~/.mpd/playlists
cd ~/.mpd/
touch database log pid state sticker.sql
mv ~/.config/mpd/mpd.conf ~/.config/mpd/mpd.conf.bak #Backup config if present
mv ~/dotfiles/mpd/mpd.conf ~/.config/mpd/
sudo systemctl disable mpd.service

# Setup ncmpcpp
sudo apt-get -y install ncmpcpp
mkdir ~/.ncmpcpp/
mv ~/.ncmpcpp/config ~/.ncmpcpp/config.bak #Backup config if present
mv ~/dotfiles/ncmpcpp/config ~/.ncmpcpp/
cd ~

# Setup Cava
sudo apt-get -y install libfftw3-dev libasound2-dev libncursesw5-dev libpulse-dev libtool automake autoconf autogen m4
cd /tmp
git clone https://github.com/karlstav/cava.git
cd cava
./autogen.sh
./configure
sudo make install
mkdir ~/.config/cava
mv ~/.config/cava/config ~/.config/cava/config.bak #Backup config if present
mv ~/dotfiles/cava/config ~/.config/cava

# Setup Urxvt
sudo apt-get -y install rxvt-unicode-256color

# Install zsh
sudo apt-get -y install zsh

# Install zprezto
cat << 'EOF' >> /tmp/zpresto-install.sh
#!/usr/bin/zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

setopt EXTENDED_GLOB

for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
chsh -s /bin/zsh

EOF

chmod +x /tmp/zpresto-install.sh
/tmp/zpresto-install.sh

mv ~/dotfiles/zsh/.zshrc ~/.zshrc
mv ~/dotfiles/zsh/zpreztorc ~/.zpreztorc

# Cleanup
cd ~
rm -rf dotfiles/
sudo apt-get -y autoremove
