#!/bin/bash

export ALL_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890

# 不让刷新镜像列表
sudo systemctl stop reflector.service
sudo systemctl disable reflector.service

# 配置pacman.conf
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
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

# 添加中国源,设置powerpill的SigLevel(签名文件) 等
if [[ $(grep -C1 "\[core\]" /etc/pacman.conf | grep -c SigLevel) = 0 ]]; then
	sudo sed -i '/\[core\]/ a SigLevel = PackageRequired' /etc/pacman.conf
fi
if [[ $(grep -C1 "\[extra\]" /etc/pacman.conf | grep -c SigLevel) = 0 ]]; then
	sudo sed -i '/\[extra\]/ a SigLevel = PackageRequired' /etc/pacman.conf
fi
if [[ $(grep -C1 "\[community\]" /etc/pacman.conf | grep -c SigLevel) = 0 ]]; then
	sudo sed -i '/\[community\]/ a SigLevel = PackageRequired' /etc/pacman.conf
fi
if [[ $(grep -C2 "\[multilib\]" /etc/pacman.conf | grep -c '^Include') = 0 ]]; then
	sudo sed -i '/\[multilib\]/ a Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
fi
if [[ $(grep -C1 "\[multilib\]" /etc/pacman.conf | grep -c SigLevel) = 0 ]]; then
	sudo sed -i '/\[multilib\]/ a SigLevel = PackageRequired' /etc/pacman.conf
fi
if [[ $(grep -C1 "\[archlinuxcn\]" /etc/pacman.conf | grep -c SigLevel) = 0 ]]; then
	sudo sed -i '/\[archlinuxcn\]/ a SigLevel = PackageRequired' /etc/pacman.conf
fi
if [[ $(grep -c fileencoding /etc/pacman.conf) = 0 ]]; then
	echo '
# vim:fileencoding=utf-8:ft=conf' | sudo tee -a /etc/pacman.conf
fi

installPowerpill() {
    sudo pacman -Syy
	# powerpill 加速版pacman
	sudo pacman -S --needed --noconfirm pacman-contrib powerpill reflector

    which powerpill >/dev/null
	if [[ $? == 0 ]]; then
		sudo powerpill -S --needed --noconfirm archlinuxcn-keyring archlinux-keyring
		sudo powerpill -S --needed --noconfirm yay paru
	else
		sudo pacman -S --needed --noconfirm archlinuxcn-keyring archlinux-keyring
		sudo pacman -S --needed --noconfirm yay paru
	fi
}

# vim:fileencoding=utf-8:ft=sh:foldmethod=marker
