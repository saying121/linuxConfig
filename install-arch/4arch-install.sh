#!/bin/bash

../proxy.sh

pacMan="sudo pacman -S --needed --noconfirm"

# kde桌面，终端
$pacMan kitty wezterm \
    networkmanager wget sddm plasma

systemctl enable --now sddm NetworkManager

# 中文字体
$pacMan adobe-source-han-serif-cn-fonts \
    adobe-source-han-sans-cn-fonts \
    wqy-zenhei wqy-microhei noto-fonts-cjk noto-fonts-emoji \
    noto-fonts-extra ttf-hack-nerd \
    ttf-maplemono ttf-maplemono-cn ttf-maplemono-nf ttf-maplemono-nf-cn

$pacMan vim zsh wget curl neovim dhcpcd iwd sudo git
