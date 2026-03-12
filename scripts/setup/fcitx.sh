#!/usr/bin/env bash

pacMan="sudo pacman -S --needed --noconfirm"

$pacMan fcitx5-im fcitx5-chinese-addons fcitx5-pinyin-moegirl \
    fcitx5-pinyin-zhwiki fcitx5-table-extra fcitx5-table-other vim-fcitx xclip

paru -S --needed --noconfirm catppuccin-fcitx5-git


if [[ $(grep -c fcitx /etc/environment) = 0 ]]; then
    echo '
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
QT_IM_MODULES=wayland;fcitx;ibus
XMODIFIERS="@im=fcitx"
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
XIM_PROGRAM="fcitx5"
XIM="fcitx5"
XIM_ARGS="-d"
ECORE_IMF_MODULE="xim"
' | sudo tee -a /etc/environment
fi
