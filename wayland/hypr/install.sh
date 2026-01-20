#!/bin/bash

get_package_manager() {
    if [[ $(grep -c arch /etc/os-release) != 0 ]]; then
        echo "sudo pacman -S --needed --noconfirm"
    else
        echo 'Can not use.'
        exit 0
    fi
}
pacMan=$(get_package_manager)
aurPkg='yay -S --needed --noconfirm'

# 通知,bar,剪贴板
$pacMan waybar otf-font-awesome \
    cliphist wl-clipboard \
    swaylock-effects hypridle \
    qt5-wayland qt6-wayland \
    xdg-desktop-portal-hyprland xdg-desktop-portal \
    brightnessctl wlsunset swaync
    # mako
    # gnome-calendar \

$pacMan pipewire wireplumber slurp grim
$aurPkg flameshot-git gojq satty swayosd-git

# xrandr-wlr-randr,xprop-wdisplays
$aurPkg wlr-randr wl-color-picker wl-delicolour-picker hyprpicker hyprprop
