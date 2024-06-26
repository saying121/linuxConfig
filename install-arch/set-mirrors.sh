#!/bin/bash

../proxy.sh

source ./set-pacman.sh

# 修改/etc/pacman.d/mirrorlist，插入中国源
echo 'Server = http://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.aliyun.com/archlinux/$repo/os/$arch
Server = https://mirrors.aliyun.com/archlinux/$repo/os/$arch
Server = http://mirrors.163.com/archlinux/$repo/os/$arch' | sudo tee /etc/pacman.d/mirrorlist

sudo pacman -Syyuu --noconfirm

sudo pacman -Fyy
