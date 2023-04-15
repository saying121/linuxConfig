#!/bin/bash

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
# 用~/.xprofile更好
# echo 'LANG=en_US.UTF-8' >>/etc/locale.conf

timedatectl set-ntp true
hwclock --systohc

echo "

*******************************
****  Input root's passwd  ****
*******************************
"
passwd
read -p '

***********************************************
**** Creat a new user,input your username: ****
***********************************************
' username
useradd -m -G wheel -s /bin/zsh "$username"
passwd "$username"
unset username

chmod u+w /etc/sudoers
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

echo "\e[1;33mcheck /etc/sudoers\e[0m"
echo "\e[1;33mManual edit visudo command's %wheel ALL=(ALL:ALL)ALL\e[0m"
