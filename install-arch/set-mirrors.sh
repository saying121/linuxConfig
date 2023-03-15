#!/bin/bash

export ALL_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890

source ./set-pacman.sh

# 修改/etc/pacman.d/mirrorlist，插入中国源
echo 'Server = http://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.aliyun.com/archlinux/$repo/os/$arch
Server = https://mirrors.aliyun.com/archlinux/$repo/os/$arch
Server = http://mirrors.163.com/archlinux/$repo/os/$arch' | sudo tee /etc/pacman.d/mirrorlist

installPowerpill

which powerpill >/dev/null
if [[ $? == 0 ]]; then
	sudo powerpill -Syyuu --noconfirm
else
	sudo pacman -Syyuu --noconfirm
fi
sudo pacman -Fyy
