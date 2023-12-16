#!/bin/bash

export ALL_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890

git config --global https.proxy 'http://127.0.0.1:7890'
git config --global http.proxy 'http://127.0.0.1:7890'

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

~/.linuxConfig/must_install.sh

$aurPkg todotxt snapper bluetuith-bin

# 计算ip的工具
$pacMan ipcalc

$pacMan sshfs python-nautilus kdeconnect

# Music
$aurPkg music-you-bin

# theme
$pacMan adwaita-qt5 adwaita-qt6
# sddm theme,分多次安装，有的会安装失败
$aurPkg sddm-theme-tokyo-night
$aurPkg sddm-theme-aerial-git
$aurPkg sddm-theme-astronaut
$aurPkg sddm-theme-corners-git
$aurPkg sddm-nordic-theme-git
$pacMan plasma packagekit-qt5 packagekit appstream-qt appstream

# 动态壁纸
# $aurPkg renderdoc plasma5-wallpapers-wallpaper-engine
$pacMan gifsicle ffmpeg
$aurPkg linux-wallpaperengine-git
# komorebi

# installVirtualBox
$pacMan virtualbox virtualbox-host-dkms
sudo gpasswd -a "$USER" vboxusers
newgrp vboxusers

$pacMan wine pkgstats

# 各种查看系统信息的软件
$pacMan htop atop iotop iftop glances nvtop sysstat plasma-systemmonitor
# btm 启动 bottom
$aurPkg bottom cpufetch hardinfo-git # `gpufetch-git

# markdown browser
$aurPkg frogmouth carbonyl

installWaydroid() {
    $pacMan waydroid linux-zen linux-zen-headers
    $aurPkg waydroid-image python-pyclip
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}
# installWaydroid

$aurPkg com.qq.weixin.deepin com.qq.weixin.work.deepin linuxqq-firejail

$pacMan dust procs tealdeer

# postgres, mysql, sqlite, mysql, redis
$pacMan pgcli mycli litecli mssql-cli iredis
# aws,Postgres meta commands.
pip install --break-system-packages athenacli pgspecial
$pacMan vhs tokei

$pacMan auto-cpufreq
sudo systemctl enable --now auto-cpufreq.service

$pacMan easyeffects calf lsp-plugins-lv2 zam-plugins-lv2 mda.lv2 yelp

# 3D
# $pacMan blender

# $pacMan mariadb
# sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
# sudo systemctl enable mariadb.service
# sudo systemctl start mariadb.service

# $pacMan orca festival espeak-ng
