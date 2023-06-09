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

# 计算ip的工具
$pacMan ipcalc

$pacMan sshfs python-nautilus kdeconnect

# Music
$aurPkg yesplaymusic netease-cloud-music

# theme
$pacMan adwaita-qt5 adwaita-qt6
# sddm theme,分多次安装，有的会安装失败
$aurPkg sddm-theme-tokyo-night
$aurPkg sddm-theme-aerial-git
$aurPkg sddm-theme-astronaut
$aurPkg sddm-theme-corners-git
$aurPkg sddm-nordic-theme-git
sudo "$pacMan" plasma packagekit-qt5 packagekit appstream-qt appstream

# 动态壁纸
# sudo $pacMan extra-cmake-modules plasma-framework gst-libav \
#     base-devel mpv python-websockets qt5-declarative qt5-websockets qt5-webchannel \
#     vulkan-headers cmake glfw-x11 vulkan-devel vulkan-radeon
# $aurPkg renderdoc plasma5-wallpapers-wallpaper-engine
sudo "$pacMan" gifsicle ffmpeg
$aurPkg linux-wallpaperengine-git # komorebi
# linux-wallpaperengine-wayland-git

# installVirtualBox
sudo "$pacMan" virtualbox virtualbox-host-dkms
sudo gpasswd -a "$USER" vboxusers
newgrp vboxusers

sudo "$pacMan" wine pkgstats

# 各种查看系统信息的软件
sudo "$pacMan" htop atop iotop iftop glances nvtop sysstat plasma-systemmonitor
$aurPkg gotop cpufetch hardinfo neofetch # `gpufetch-git

# markdown browser
$aurPkg frogmouth carbonyl

installWaydroid() {
    sudo "$pacMan" waydroid linux-zen linux-zen-headers
    $aurPkg waydroid-image python-pyclip
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}
# installWaydroid

$aurPkg com.qq.weixin.deepin com.qq.weixin.work.deepin linuxqq-firejail

$pacMan dust procs tealdeer

# $pacMan mariadb
# sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
# sudo systemctl enable mariadb.service
# sudo systemctl start mariadb.service

unset pacMan aurPkg
