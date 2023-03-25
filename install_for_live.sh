#!/bin/bash

export ALL_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890
# link config
~/.linuxConfig/linkConfig.sh

get_package_manager() {
    if [[ $(grep -c arch /etc/os-release) != 0 ]]; then
        echo "pacman -S --needed --noconfirm"
    else
        echo 'Can not use.'
        exit 0
    fi
}
pacMan=$(get_package_manager)

# 必装
sudo pacman -Syu --noconfirm
sudo $pacMan archlinuxcn-keyring archlinux-keyring
# if [[ $? != 0 ]]; then
# if ! sudo pacman -S --needed --noconfirm archlinuxcn-keyring; then
# 	sudo rm -rf /etc/pacman.d/gnupg
# 	sudo pacman-key --init
# 	sudo pacman-key --populate archlinux
# 	sudo pacman-key --populate archlinuxcn
# fi

sudo pacman -Syyu --noconfirm
sudo $pacMan yay paru

sudo $pacMan kitty terminology wezterm
# 开发工具
sudo $pacMan inetutils dnsutils networkmanager fd tree \
    clash

sudo $pacMan rustup rust-analyzer
rustup install stable beta nightly
rustup component add rust-analyzer rustfmt
yay -S --noconfirm codelldb

# 调用关于clash的脚本，配置clash
~/.linuxConfig/scripts/configClash.sh

sudo $pacMan figlet ffmpeg \
    bc man net-tools psmisc sudo ripgrep fzf trash-cli wget \
    vim bash exa bat \
    neovim lolcat git lazygit composer eslint cronie sqlite

~/.linuxConfig/nvim/install.sh

sudo $pacMan zsh zsh-autosuggestions zsh-syntax-highlighting
# 安装oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# omz plug
pip install thefuck
~/.linuxConfig/shells/ohmyzsh.sh

# ranger
sudo $pacMan ranger
sudo $pacMan libcaca w3m imagemagick librsvg ffmpegthumbnailer highlight p7zip atool \
    libarchive unrar unzip poppler calibre epub-thumbnailer-git transmission-cli \
    perl-image-exiftool mediainfo odt2txt jq jupyter-nbconvert fontforge djvulibre \
    openscad drawio-desktop-bin
cd ~/.linuxConfig && git submodule update --init --recursive || echo ''

installI3() {
    # 取代xorg-xbacklight
    sudo $pacMan acpilight betterlockscreen dex
    sudo chmod 666 /sys/class/backlight/amdgpu_bl0/brightness
    yay -S --needed --noconfirm i3wm i3status i3status-rust feh xidlehook
    # i3-gaps-kde-git
    # ~/.linuxConfig/kde/use-i3.sh
}

# 安装lf文件浏览器
sudo $pacMan lf
sudo $pacMan perl-image-exiftool mdcat libreoffice-fresh highlight git-delta atool bat chafa colordiff coreutils fontforge gnupg poppler source-highlight transmission-cli jq pandoc mupdf-tools ffmpegthumbnailer xournalpp openscad ueberzug
# sudo $pacMan poppler atool unrar p7zip w3m jq pandoc git-delta mupdf-tools perl-image-exiftool mdcat bat highlight libreoffice-fresh imagemagick ffmpegthumbnailer xournalpp transmission-cli openscad
yay -S --needed --noconfirm ctpv-git stpv-git epub2txt-git

allInstall() {
    # sudo pacman -Syu --noconfirm
    sudo $pacMan foliate festival festival-english \
        openssh ntfs-3g exfat-utils viu \
        pandoc xdg-utils youtube-dl numlockx rsync arch-install-scripts \
        gimagereader-qt tesseract-data-eng tesseract-data-chi_sim \
        alsa qbittorrent mpv

    # 缺失的驱动
    yay -S --needed --noconfirm \
        ast-firmware upd72020x-fw aic94xx-firmware wd719x-firmware
    sudo $pacMan linux-firmware-qlogic

    # 防火墙
    sudo $pacMan firewalld
    sudo systemctl enable firewalld

    # 翻译
    sudo $pacMan translate-shell ldr-translate-qt goldendict

    sudo $pacMan pacman-contrib

    # installWireshark cmd:tshark
    sudo $pacMan wireshark-qt wireshark-cli termshark kismet wifite

    # 文件管理器
    sudo $pacMan dolphin konsole qt5ct kvantum

    # 输入法相关 中文输入法,支持vim+寄存器的clip
    sudo $pacMan fcitx5-im fcitx5-chinese-addons fcitx5-pinyin-moegirl \
        fcitx5-pinyin-zhwiki fcitx5-material-color vim-fcitx xclip fcitx5-table-other

    # Music
    yay -S --needed --noconfirm \
        go-musicfox-git

    # sddm主题的依赖
    sudo $pacMan gst-libav phonon-qt5-gstreamer gst-plugins-good qt5-quickcontrols qt5-graphicaleffects qt5-multimedia
    yay -S --needed --noconfirm \
        sddm-theme-aerial-git sddm

    # x11,蓝牙耳机自动切换，pavucontrol:音量控制
    sudo $pacMan pulseaudio-bluetooth bluez bluez-utils pulsemixer \
        xorg xorg-xinit xorg-server calc python-pywal network-manager-applet \
        pulseaudio-alsa pavucontrol
    # 蓝牙前端
    sudo $pacMan blueman

    # polybar
    sudo $pacMan polybar picom
    ~/.linuxConfig/i3/polybar/install-polybar-theme.sh

    # input-remapper
    yay -S --needed --noconfirm input-remapper-git
    sudo systemctl enable input-remapper
    sudo systemctl start input-remapper
    input-remapper-control --command start --device "Keyboard K380 Keyboard" --preset "capslock+"
    input-remapper-control --command start --device "AT Translated Set 2 keyboard" --preset "capslock+"
    input-remapper-control --command start --device "SINO WEALTH Gaming KB " --preset "capslock+"

    # 各种查看系统信息的软件
    sudo $pacMan htop atop iotop iftop glances sysstat
    yay -S --needed --noconfirm \
        gotop cpufetch hardinfo neofetch

    # 浏览器
    yay -S --needed --noconfirm \
        microsoft-edge-stable-bin google-chrome

    # 截图,录屏,剪辑
    sudo $pacMan flameshot obs-studio

    # 触摸板
    yay -S --needed --noconfirm \
        ruby-fusuma
    sudo gpasswd -a "$USER" input
    newgrp input

    # 中文字体
    sudo $pacMan adobe-source-han-serif-cn-fonts \
        adobe-source-han-sans-cn-fonts \
        wqy-zenhei wqy-microhei noto-fonts-cjk noto-fonts-emoji \
        noto-fonts-extra ttf-hack-nerd ttf-sil-padauk
    fc-cache -fv

    # rofi
    sudo $pacMan rofi
    ~/.linuxConfig/rofi/install-rofi-theme.sh

    # gnome 显示效果好一点
    sudo $pacMan polkit polkit-qt5 polkit-gnome
    # polkit-kde-agent
}

# aur才有的软件
yayInstall() {
    yay -Syyu --noconfirm
    yay -S --needed --noconfirm \
        xnviewmp fontpreview \
        wps-office-cn ttf-wps-fonts \
        rime-ls rime-essay
    # copyq  networkmanager-dmenu-bluetoothfix-git  networkmanager-dmenu-git  archlinux-tweak-tool-git
}

# 开启服务
startServer() {
    sudo systemctl enable bluetooth sshd NetworkManager sddm
    sudo systemctl start bluetooth sshd NetworkManager
}

allInstall
installI3
yayInstall
startServer

unset pacMan
