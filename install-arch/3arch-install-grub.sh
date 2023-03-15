#! /bin/bash

which powerpill >/dev/null
if [[ $? == 0 ]]; then
	pacMan="powerpill -S --needed --noconfirm"
else
    pacMan="pacman -S --needed --noconfirm"
fi

# 引导和微码
if [[ $(lscpu | grep -c AMD) != 0 ]]; then
	sudo $pacMan amd-ucode
elif [[ $(lscpu | grep -c Intel) != 0 ]]; then
	sudo $pacMan intel-ucode
fi
sudo $pacMan grub efibootmgr os-prober

unset $pacMan

# 安装grub引导
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg
