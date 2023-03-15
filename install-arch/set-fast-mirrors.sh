#!/bin/bash

export ALL_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890

source ./set-pacman.sh

# rankmirrors 命令所在包
sudo pacman -S --needed --noconfirm pacman-contrib
# 获取最快的所有中国镜像。
curl -s "https://archlinux.org/mirrorlist/?country=CN&protocol=https&use_mirror_status=on" |
	sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n all - |
	sudo tee /etc/pacman.d/mirrorlist

installPowerpill

which powerpill >/dev/null
if [[ $? == 0 ]]; then
	sudo powerpill -Syyuu --noconfirm
else
	sudo pacman -Syyuu --noconfirm
fi
sudo pacman -Fyy
