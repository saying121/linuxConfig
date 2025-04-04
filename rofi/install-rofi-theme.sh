#!/bin/bash

xhost si:localuser:root

# 截图
if [[ $(grep -c arch /etc/os-release) != 0 ]]; then
    sudo pacman -S --needed --noconfirm rofi maim viewnior alsa-utils
fi
# install rofi theme
theme() {
    git clone --depth=1 https://github.com/adi1090x/rofi.git rofi-theme
    cd rofi-theme || return
    chmod +x setup.sh
    ./setup.sh
    cd ..
    rm -rf rofi-theme
}
if [[ ! -d ~/.config/rofi/scripts ]]; then
    theme
fi

# 让该用户在以root身份运行时还能找到图片
dir="$HOME/.config/rofi/launchers/type-6"
theme='style-7'
sed -i.bak "s#\".*/.config/rofi/images/g.png#\"$HOME/.config/rofi/images/g.png#" "$dir"/$theme.rasi
