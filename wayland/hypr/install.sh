#!/bin/bash

get_package_manager() {
    if [[ $(grep -c arch /etc/os-release) != 0 ]]; then
        echo "pacman -S --needed --noconfirm"
    else
        echo 'Can not use.'
        exit 0
    fi
}
pacMan=$(get_package_manager)
aurPkg='yay -S --needed --noconfirm'

# 通知,bar,剪贴板
sudo "$pacMan" hyprland-nvidia \
    waybar-hyprland-git otf-font-awesome \
    cliphist wl-clipboard \
    swaylock-effects swayidle \
    qt5-wayland qt6-wayland \
    gnome-calendar \
    xdg-desktop-portal-hyprland-git xdg-desktop-portal \
    brightnessctl

sudo "$pacMan" pipewire wireplumber slurp grim hyprland-interactive-screenshot

# xrandr-wlr-randr,xprop-wdisplays
$aurPkg linux-wallpaperengine-wayland-git wlr-randr
