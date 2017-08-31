#/bin/bash

#get sudo permissions for script run
sudo -v

#update system
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt clean

#install i3 and other packages
sudo apt install curl compton dunst feh i3 libjsoncpp1 libmpdclient2 lxappearance rofi git wget unzip -y

#install numix icons
sudo apt install numix-icon-theme

#backup .Xresources
sudo cp ~/.Xresources ~/.Xresources.bak

#install polybar
sudo apt install build-essential cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen xcb-proto i3-wm libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev clang -y
cd /tmp
git clone --branch 3.0.5 --recursive https://github.com/jaagr/polybar
mkdir polybar/build
cd polybar/build
cmake ..
sudo make install
cd ~

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

#download config files from GitHub
cd ~
git clone https://github.com/BurningSmile/dotfiles.git

#install configs
cd ~/dotfiles/
mkdir ~/.config/polybar/
mv ./polybar/* ~/.config/polybar/
mkdir ~/.config/i3
mv ./i3/config ~/.config/i3/
mv .Xresources ~
mv ./zsh/.zshrc ~/.zshrc.bak
mkdir ~/.config/dunst
mv ./dunst/dunstrc ~/.config/dunst/dunstrc

#copy background image
mkdir ~/Pictures/backgrounds
mv ~/dotfiles/i3/Background/Mountins-Wallpaper.jpg ~/Pictures/backgrounds
mv ~/dotfiles/i3/Background/firewatch_ARC.jpg ~/Pictures/backgrounds

#install vim [Techinally gvim but i still use it as terminal vim. Used to get yank to also yank to system clipboard]
sudo apt install vim-gnome -y
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cd ~/dotfiles/vim
mkdir ~/.vim/
cp -r .vim/. ~/.vim/
mv ~/vimrc ~/vimrc.bak # Backup vimrc if present
mv .vimrc ~
cd ~

#install vim plugins
vim +PlugClean +PlugInstall +PlugUpdate +q! +q!

#install you-complete-me for vim auto completion.
sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git -y
mkdir /tmp/ycm_build
cd /tmp/ycm_build
cmake -G "Unix Makefiles" . ~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp
cmake -G "Unix Makefiles" -DUSE_SYSTEM_LIBCLANG=ON . ~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp
cmake --build . --target ycm_core --config Release
cd ~

#Install nodejs for vim instant markdown
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt install nodejs -y

#Install vim-instant-markdown
sudo apt install xdg-utils curl -y
sudo npm -g install instant-markdown-d

#install powerline
sudo apt install python-pip powerline fonts-powerline -y

#install tmux [If using 16.04 or newer you will need to adjust the vim copy section to use the older version of the key binds before version 2.4 Change log here: https://github.com/tmux/tmux/blob/master/CHANGES]
sudo apt install tmux xsel -y # xsel is for x copy support
cd ~/dotfiles/tmux
mv ~/.tmux.conf ~/.tmux.conf.bak # Backup Tmux.conf if present.
mv .tmux.conf ~
mv ~/dotfiles/tmux/.tmux ~
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cd ~

#install theme [This works for 16.10 and debian 9 and newer. For older versions refer to the arc theme documentation.]
sudo apt install arc-theme -y

#install htop
sudo apt install htop -y
mv ~/.config/htop/htoprc ~/.config/htop/htoprc.bak # Backup htoprc if present
cd ~/dotfiles/htop
mkdir ~/.config/htop
mv htoprc ~/.config/htop/
cd ~

#setup mpd and mpc
sudo apt install mpd mpc -y
mkdir -p ~/.config/mpd/
mkdir -p ~/.mpd/playlists
cd ~/.mpd/
touch database log pid state sticker.sql
mv ~/.config/mpd/mpd.conf ~/.config/mpd/mpd.conf.bak #Backup config if present
mv ~/dotfiles/mpd/mpd.conf ~/.config/mpd/

#setup ncmpcpp
sudo apt install ncmpcpp -y
mkdir ~/.ncmpcpp/
mv ~/.ncmpcpp/config ~/.ncmpcpp/config.bak #Backup config if present
mv ~/dotfiles/ncmpcpp/config ~/.ncmpcpp/
cd ~

#setup Cava
sudo apt install libfftw3-dev libasound2-dev libncursesw5-dev libpulse-dev libtool automake -y
cd /tmp
git clone https://github.com/karlstav/cava.git
cd cava
./autogen.sh
./configure
make install
mkdir ~/.config/cava
mv ~/.config/cava/config ~/.config/cava/config.bak #Backup config if present
mv ~/dotfiles/cava/config ~/.config/cava

#setup urxvt
sudo apt install rxvt-unicode-256color -y

#install the fuck for fixing yoru last command if you typed it wrong
sudo apt install thefuck -y

#install zshell
sudo apt install  zsh -y

#cleanup
cd ~
rm -rf dotfiles/
sudo apt autoremove -y

#install ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
