#!/bin/bash

../proxy.sh

source ./set-pacman.sh

# rankmirrors 命令所在包
sudo pacman -S --needed --noconfirm pacman-contrib
# 获取最快的所有中国镜像。
curl -s "https://archlinux.org/mirrorlist/?country=CN&protocol=https&use_mirror_status=on" |
    sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n all - |
    sudo tee /etc/pacman.d/mirrorlist

sudo pacman -Syyuu --noconfirm
sudo pacman -Fyy
