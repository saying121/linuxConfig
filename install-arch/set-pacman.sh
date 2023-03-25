#!/bin/bash

export ALL_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890

# 不让刷新镜像列表
sudo systemctl stop reflector.service
sudo systemctl disable reflector.service

# 配置pacman.conf
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i "s/^#ParallelDownloads .*/ParallelDownloads = 10/" /etc/pacman.conf
sudo sed -i 's/^#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf

sudo sed -i "s/^#\[multilib\]/\[multilib\]/" /etc/pacman.conf

if [[ $(grep "\[archlinuxcn\]" -c /etc/pacman.conf) = 0 ]]; then
    # shellcheck disable=2016
    echo '
[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
Server = http://mirrors.163.com/archlinux-cn/$arch
' | sudo tee -a /etc/pacman.conf
fi

if [[ $(grep -c fileencoding /etc/pacman.conf) = 0 ]]; then
    echo '
# vim:fileencoding=utf-8:ft=conf' | sudo tee -a /etc/pacman.conf
fi

sudo pacman -Syy
sudo pacman -S --needed --noconfirm pacman-contrib

sudo pacman -S --needed --noconfirm archlinuxcn-keyring archlinux-keyring
sudo pacman -S --needed --noconfirm yay paru

# vim:fileencoding=utf-8:ft=sh:foldmethod=marker
