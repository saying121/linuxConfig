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

$pacMan fcitx5-im fcitx5-chinese-addons fcitx5-pinyin-moegirl \
    fcitx5-pinyin-zhwiki fcitx5-table-extra fcitx5-table-other vim-fcitx xclip \
    vim zsh wget curl neovim dhcpcd iwd sudo git

paru -S --needed --noconfirm catppuccin-fcitx5-git

# fcitx5的设置
if [[ $(grep -c fcitx /etc/environment) = 0 ]]; then
    echo '
# GTK_IM_MODULE=fcitx5
# QT_IM_MODULE=fcitx5
XMODIFIERS="@im=fcitx5"
SDL_IM_MODULE=fcitx5
GLFW_IM_MODULE=ibus
XIM_PROGRAM="fcitx5"
XIM="fcitx5"
XIM_ARGS="-d"
ECORE_IMF_MODULE="xim"
QT_IM_MODULE=fcitx # wechat
' | sudo tee -a /etc/environment
fi
