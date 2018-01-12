#!/bin/bash
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
reflector --country US -p http --save /etc/pacman.d/mirrorlist
