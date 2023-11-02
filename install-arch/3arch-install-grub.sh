#! /bin/bash

pacMan="sudo pacman -S --needed --noconfirm"

# 引导和微码
if [[ $(lscpu | grep -c AMD) != 0 ]]; then
    $pacMan amd-ucode
elif [[ $(lscpu | grep -c Intel) != 0 ]]; then
    $pacMan intel-ucode
fi
$pacMan grub efibootmgr os-prober

# 安装grub引导
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg
