#!/usr/bin/env bash

./proxy.sh
socket=http://127.0.0.1:7897

# git config --global https.proxy $socket
# git config --global http.proxy $socket
git config --global http.postBuffer 524288000
git config credential.helper 'cache --timeout=3600'
git config --global url."git@github.com:".insteadOf https://github.com
git config --global open.https://ssh.github.com.domain github.com # for git-open

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
$aurPkg adwaita-qt5-git adwaita-qt6-git kvantum-theme-libawaita-git
# sddm theme,分多次安装，有的会安装失败
$aurPkg sddm-theme-tokyo-night
$aurPkg sddm-theme-aerial-git
$aurPkg sddm-theme-astronaut
$aurPkg sddm-theme-corners-git
$pacMan plasma packagekit-qt5 packagekit appstream-qt appstream

# 动态壁纸
# $aurPkg renderdoc plasma5-wallpapers-wallpaper-engine
$pacMan gifsicle ffmpeg
$aurPkg linux-wallpaperengine-git
# komorebi

# installVirtualBox
# $pacMan virtualbox virtualbox-host-dkms
# sudo gpasswd -a "$USER" vboxusers
# newgrp vboxusers

$pacMan virt-manager virt-viewer virt-install

$pacMan pkgstats

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

$aurPkg xwaylandvideobridge wemeet-bin

$aurPkg bitwise programmer-calculator
