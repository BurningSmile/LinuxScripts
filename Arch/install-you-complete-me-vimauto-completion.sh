#!/bin/bash
sudo pacman -S cmake clang python python3 --noconfirm
mkdir ~/ycm_build
cd ~/ycm_build
cmake -G "Unix Makefiles" . ~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp
cmake -G "Unix Makefiles" -DUSE_SYSTEM_LIBCLANG=ON . ~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp
cmake --build . --target ycm_core --config Release
cd ~
rm -rf ~/ycm_build
