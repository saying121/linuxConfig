#! /bin/bash

pacMan="sudo pacman -S --needed --noconfirm"

$pacMan grub efibootmgr os-prober

# 安装grub引导
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg
