#!/bin/bash

sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

if [[ -e /etc/pacman.d/chaotic-mirrorlist ]]; then
    if [[ $(grep "\[chaotic-aur\]" -c /etc/pacman.conf) = 0 ]]; then
        echo "
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
" | sudo tee -a /etc/pacman.conf
    fi
fi

sudo pacman -Syy --noconfirm
sudo pacman -Fyy --noconfirm
