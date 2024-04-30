#!/bin/bash

export ALL_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890
# link config
~/.linuxConfig/linkConfig.sh

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

# 必装
# sudo pacman -Syu --noconfirm
$pacMan archlinuxcn-keyring archlinux-keyring
# if [[ $? != 0 ]]; then
#     if ! sudo pacman -S --needed --noconfirm archlinuxcn-keyring; then
#         sudo rm -rf /etc/pacman.d/gnupg
#         sudo pacman-key --init
#         sudo pacman-key --populate archlinux
#         sudo pacman-key --populate archlinuxcn
#     fi
# fi

sudo pacman -Syyu --noconfirm
$pacMan yay paru
# yay -Syyu --noconfirm

$pacMan kitty terminology wezterm ttf-nerd-fonts-symbols-mono

# 开发工具
$pacMan inetutils dnsutils networkmanager fd tree \
    clash
# 路由跟踪
$pacMan traceroute mtr

# 调用关于clash的脚本，配置clash
# echo "
#
# *******************************************
# **** 填入clash链接，也可以不填直接回车 ****
# *******************************************
# "
# read -r link
# ~/.linuxConfig/scripts/configClash.sh "$link"

$pacMan figlet ffmpeg \
    bc man net-tools psmisc sudo ripgrep fzf trash-cli wget \
    vim bash eza bat \
    neovim lolcat git lazygit composer eslint cronie sqlite \
    engrampa pkgfile

# 图像查看
$pacMan gwenview nomacs \
    opencv-samples vtk glew qt6-base hdf5 opencl-icd-loader java-runtime
$pacMan adios2 cgns ffmpeg fmt gdal gl2ps glew gnuplot graphviz hdf5 java-runtime=11 jsoncpp libarchive libharu liblas lz4 mariadb-libs netcdf openimagedenoise openmpi openvdb openvr openxr ospray pdal postgresql-libs proj python python-matplotlib python-mpi4py qt5-declarative sqlite tk unixodbc verdict

# neovim,vim plugins
# ~/.linuxConfig/nvim/install.sh

# zsh
~/.linuxConfig/shells/install_zi.sh
$pacMan rustup starship
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
rustup install stable
cargo install os_info_cli
$aurPkg aur/ueberzugpp

# ranger
$pacMan ranger
$aurPkg libcaca w3m imagemagick librsvg ffmpegthumbnailer highlight p7zip atool \
    libarchive unrar unzip poppler calibre transmission-cli \
    perl-image-exiftool mediainfo odt2txt jq jupyter-nbconvert fontforge djvulibre \
    openscad drawio-desktop-bin
$aurPkg epub-thumbnailer-git
cd ~/.linuxConfig && git submodule update --init --recursive || echo ''

# 安装lf文件浏览器
$aurPkg lf-sixel-git
$pacMan perl-image-exiftool mdcat libreoffice-fresh highlight git-delta atool bat chafa colordiff coreutils fontforge gnupg poppler source-highlight transmission-cli jq pandoc mupdf-tools ffmpegthumbnailer xournalpp openscad
$aurPkg ctpv-git epub2txt-git

# sudo pacman -Syu --noconfirm
$pacMan foliate festival festival-english \
    openssh ntfs-3g exfat-utils viu \
    pandoc xdg-utils youtube-dl numlockx rsync arch-install-scripts \
    gimagereader-qt tesseract-data-eng tesseract-data-chi_sim \
    qbittorrent steam mpv

# 缺失的驱动
$aurPkg ast-firmware upd72020x-fw aic94xx-firmware wd719x-firmware
$pacMan linux-firmware-qlogic

# 防火墙
$pacMan firewalld
sudo systemctl enable firewalld

# 翻译
$pacMan translate-shell pot-translation

$pacMan pacman-contrib

# installWireshark cmd:tshark
$pacMan wireshark-qt wireshark-cli termshark kismet wifite

# 文件管理器
$pacMan dolphin konsole qt5ct kvantum kali-themes

# 输入法相关 中文输入法,支持vim+寄存器的clip
$pacMan fcitx5-im fcitx5-chinese-addons fcitx5-pinyin-moegirl \
    fcitx5-pinyin-zhwiki vim-fcitx xclip fcitx5-table-other catppuccin-fcitx5-git

# Music
$aurPkg go-musicfox-git

# sddm主题的依赖
$pacMan gst-libav phonon-qt5-gstreamer gst-plugins-good qt5-quickcontrols qt5-graphicaleffects qt5-multimedia
$aurPkg sddm sddm-conf-git xinit-xsession
$aurPkg sddm-theme-aerial-git

# x11,蓝牙耳机自动切换，pavucontrol:音量控制,安装 pipewire-pulse包. 它将代替 pulseaudio包 和 pulseaudio-bluetooth包
$pacMan pipewire-pulse bluez bluez-utils pulsemixer \
    xorg xorg-xinit xorg-server calc python-pywal network-manager-applet \
    pulseaudio-alsa pavucontrol
$pacMan redshift

# 锁屏
$pacMan betterlockscreen xidlehook dex
betterlockscreen -u ~/.linuxConfig/wallpaperengine/somePictures

# 电源时间
xset dpms 1200 1800 2400
# 屏保时间
xset s 900 900
sudo systemctl enable betterlockscreen@"$USER"

# i3
$aurPkg i3-wm i3status i3status-rust autotiling feh
# makepkg -si ~/.linuxConfig/i3/picom/PKGBUILD

$pacMan sway

# 蓝牙前端
$pacMan blueman
xset +dpms

# 下载工具
$pacMan lux-dl

# polybar
# $pacMan polybar
# ~/.linuxConfig/i3/polybar/install-polybar-theme.sh

# install Gimp
$pacMan gimp gvfs gutenprint

# input-remapper
$aurPkg input-remapper-git
sudo systemctl enable input-remapper
sudo systemctl start input-remapper
input-remapper-control --command start --device "Keyboard K380 Keyboard" --preset "capslock+"
input-remapper-control --command start --device "AT Translated Set 2 keyboard" --preset "capslock+"
input-remapper-control --command start --device "SINO WEALTH Gaming KB " --preset "capslock+"

# 各种查看系统信息的软件
$pacMan htop atop iotop iftop glances sysstat plasma-systemmonitor
$aurPkg gotop cpufetch fastfetch onefetch fetchfetch hardinfo

# 浏览器
$aurPkg microsoft-edge-stable-bin google-chrome

# 编辑器，ide
$aurPkg visual-studio-code-bin # intellij-idea-ultimate-edition

# 截图,录屏,剪辑
$pacMan flameshot-git obs-studio wlrobs-hg shotcut v4l2loopback-dkms
sudo gpasswd -a "$USER" video

# 热点
$pacMan linux-wifi-hotspot bash-completion haveged

# 中文字体
$pacMan adobe-source-han-serif-cn-fonts \
    adobe-source-han-sans-cn-fonts \
    wqy-zenhei wqy-microhei noto-fonts-cjk noto-fonts-emoji \
    noto-fonts-extra ttf-hack-nerd ttf-sil-padauk \
    nerd-fonts-complete
fc-cache -fv

# rofi
$pacMan rofi-lbon-wayland
~/.linuxConfig/rofi/install-rofi-theme.sh

# gnome 显示效果好一点
$pacMan polkit polkit-qt5 polkit-gnome # polkit-kde-agent

# pdf
$pacMan python-pymupdf python-fonttools python-pillow bibtool termpdf.py-git

# 字体，录制gif
$aurPkg fontpreview gifine

# copyq networkmanager-dmenu-bluetoothfix-git networkmanager-dmenu-git archlinux-tweak-tool-git

# 读电子书
$pacMan koodo-reader-bin

# 开启服务
sudo systemctl enable bluetooth sshd NetworkManager sddm
sudo systemctl start bluetooth sshd NetworkManager
