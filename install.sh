#!/bin/bash

export ALL_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890

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

~/.linuxConfig/must_install.sh

# cargo install leetcode-cli

$aurPkg todotxt

# Music
$aurPkg yesplaymusic netease-cloud-music

# sddm theme
$aurPkg sddm-theme-aerial-git sddm-theme-catppuccin-git \
    sddm-theme-astronaut sddm-elegant-theme-git sddm-catppuccin-git \
    sddm-theme-corners-git simplicity-sddm-theme-git sddm-sugar-dark \
    sddm-nordic-theme-git \
    sddm-theme-deepin-git  sddm-theme-tokyo-night
sudo $pacMan plasma packagekit-qt5 packagekit appstream-qt appstream

# 动态壁纸
# sudo $pacMan extra-cmake-modules plasma-framework gst-libav \
    #     base-devel mpv python-websockets qt5-declarative qt5-websockets qt5-webchannel \
    #     vulkan-headers cmake glfw-x11 vulkan-devel vulkan-radeon
# $aurPkg renderdoc plasma5-wallpapers-wallpaper-engine
sudo $pacMan gifsicle ffmpeg
$aurPkg linux-wallpaperengine-git # komorebi

# installVirtualBox
sudo $pacMan virtualbox virtualbox-host-dkms
sudo gpasswd -a "$USER" vboxusers
newgrp vboxusers

sudo $pacMan wine

# 各种查看系统信息的软件
sudo $pacMan htop atop iotop iftop glances nvtop sysstat plasma-systemmonitor
$aurPkg gotop cpufetch hardinfo neofetch # `gpufetch-git
# pip3 install nvitop gpustat

# markdown browser
pip3 install frogmouth carbonyl

installWaydroid() {
    sudo $pacMan waydroid linux-zen linux-zen-headers
    $aurPkg waydroid-image python-pyclip
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}
# installWaydroid
$aurPkg com.qq.weixin.deepin com.qq.weixin.work.deepin-x11 linuxqq-firejail

unset pacMan aurPkg
