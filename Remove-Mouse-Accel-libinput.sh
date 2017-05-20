#!/bin/bash
sudo -v
sudo touch /etc/X11/xorg.conf.d/50-mouse-acceleration.conf
sudo cat <<EOF >> /etc/X11/xorg.conf.d/50-mouse-acceleration.conf
Section "InputClass"
	Identifier "My Mouse"
	Driver "libinput"
	MatchIsPointer "yes"
	Option "AccelProfile" "flat"
EndSection

EOF
