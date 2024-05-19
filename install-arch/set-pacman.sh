#!/bin/bash

../proxy.sh

# 不让刷新镜像列表
sudo systemctl stop reflector.service
sudo systemctl disable reflector.service

# 配置pacman.conf
sudo sed -i.bak 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i.bak "s/^#ParallelDownloads .*/ParallelDownloads = 40/" /etc/pacman.conf
sudo sed -i.bak 's/^#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf

sudo sed -i.bak "s/^#\[multilib\]/\[multilib\]/" /etc/pacman.conf
sudo sed -i.bak '/\[multilib\]/ {n;s/^#//;}' /etc/pacman.conf

if [[ $(grep "\[archlinuxcn\]" -c /etc/pacman.conf) = 0 ]]; then
    # shellcheck disable=2016
    echo '
[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
Server = http://mirrors.163.com/archlinux-cn/$arch
' | sudo tee -a /etc/pacman.conf
fi

sudo pacman -Syy --noconfirm
sudo pacman -Fyy --noconfirm

sudo pacman -S --needed --noconfirm pacman-contrib
sudo pacman -S --needed --noconfirm archlinuxcn-keyring archlinux-keyring
sudo pacman -S --needed --noconfirm yay paru
