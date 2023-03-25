#!/bin/bash

# 环境变量
if [[ $(grep -c mason /etc/profile) == 0 ]]; then
    # shellcheck disable=2016
    echo '
export ALL_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890
export NO_PROXY=baidu.com,qq.com

export EDITOR='nvim'

# input method
export ECORE_IMF_MODULE="xim"
export XMODIFIERS="@im=none"

export PATH=~/.cargo/bin:~/.local/bin:$PATH
export PATH=$PATH:~/.local/share/nvim/mason/bin
export PATH=/mnt/c/Program\ Files\ \(x86\)/Microsoft/Edge/Application:$PATH

export PATH=~/go/bin:$PATH
export PATH=/usr/lib/w3m:$PATH
export PATH=~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin:$PATH
export GOPATH=~/go

export XDG_DATA_HOME=~/.local/share
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache

export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
    ' | sudo tee -a /etc/profile

    source /etc/profile
fi

[[ -d ~/.config ]] || mkdir ~/.config
[[ -d ~/.config/systemd/user ]] || mkdir -p ~/.config/systemd/user
# dex 设置自启动应用
cp -f ~/.linuxConfig/custom-services/autostart.service ~/.config/systemd/user
cp -f ~/.linuxConfig/custom-services/autostart.target ~/.config/systemd/user
sudo systemctl --user daemon-reload
sudo systemctl --user enable autostart.service

# qt5ct
rm -rf ~/.config/qt5ct
ln -sf ~/.linuxConfig/qt5ct ~/.config
# clang-format
ln -sf ~/.linuxConfig/formatters/clang-format ~/.clang-format
# stylua
ln -sf ~/.linuxConfig/formatters/stylua ~/.config
# w3m
[[ -d ~/.w3m ]] || mkdir ~/.w3m
ln -sf ~/.linuxConfig/configs/w3m-config ~/.w3m/config
# pip
rm -rf ~/.pip
ln -sf ~/.linuxConfig/.pip ~/
# nvim
rm -rf ~/.config/nvim
ln -sf ~/.linuxConfig/nvim ~/.config
[[ -d ~/.local/share/rime-ls-nvim ]] || mkdir ~/.local/share/rime-ls-nvim
ln -sf ~/.linuxConfig/configs/rime-ls-user.yaml ~/.local/share/rime-ls-nvim/user.yaml
[[ -d ~/.vim ]] || mkdir ~/.vim
ln -sf ~/.linuxConfig/nvim/tasks.ini ~/.vim/tasks.ini
# vim
ln -sf ~/.linuxConfig/nvim/viml/init.vim ~/.vimrc
# coc
ln -sf ~/.linuxConfig/nvim/coc-config/coc-settings.json ~/.vim/coc-settings.json

# zshrc
ln -sf ~/.linuxConfig/shells/.zshrc ~/.zshrc
# bashrc
ln -sf ~/.linuxConfig/shells/bashrc ~/.bashrc
[[ -d ~/.local/shells ]] || mkdir ~/.local/shells
# ranger
rm -rf ~/.config/ranger
ln -sf ~/.linuxConfig/ranger ~/.config
# lf
rm -rf ~/.config/lf
ln -sf ~/.linuxConfig/lf ~/.config
# tldr
ln -sf ~/.linuxConfig/configs/tldrrc ~/.tldrrc
# npm
ln -sf ~/.linuxConfig/configs/npmrc ~/.npmrc
# music
[[ -d ~/.go-musicfox ]] || mkdir ~/.go-musicfox
ln -sf ~/.linuxConfig/configs/go-musicfox.ini ~/.go-musicfox/go-musicfox.ini
# leetcode-cli
[[ -d ~/.leetcode ]] || mkdir ~/.leetcode
ln -sf ~/.linuxConfig/configs/leetcode.toml ~/.leetcode/leetcode.toml

# flameshot
[[ -d ~/.config/flameshot ]] || mkdir -p ~/.config/flameshot
ln -sf ~/.linuxConfig/configs/flameshot.ini ~/.config/flameshot/flameshot.ini
# kitty
rm -rf ~/.config/kitty
ln -sf ~/.linuxConfig/kitty ~/.config
# wezterm
rm -rf ~/.config/wezterm
ln -sf ~/.linuxConfig/wezterm ~/.config
# terminology
rm -rf ~/.config/terminology
ln -sf ~/.linuxConfig/terminology ~/.config
# konsave config
[[ -d ~/.config/konsave ]] || mkdir -p ~/.config/konsave
ln -sf ~/.linuxConfig/configs/konsave-conf.yaml ~/.config/konsave/conf.yaml
# keymap
rm -rf ~/.config/input-remapper
ln -sf ~/.linuxConfig/input-remapper ~/.config
ln -sf ~/.linuxConfig/input-remapper/presets/AT\ Translated\ Set\ 2\ keyboard/capslock+.json ~/.linuxConfig/input-remapper/presets/Keyboard\ K380\ Keyboard/capslock+.json
ln -sf ~/.linuxConfig/input-remapper/presets/AT\ Translated\ Set\ 2\ keyboard/capslock+.json ~/.linuxConfig/input-remapper/presets/SINO\ WEALTH\ Gaming\ KB\ /capslock+.json
# 触摸板手势
rm -rf ~/.config/fusuma
ln -sf ~/.linuxConfig/fusuma ~/.config
# i3
ln -sf ~/.linuxConfig/i3 ~/.config
ln -sf ~/.linuxConfig/i3/i3status-rust ~/.config
ln -sf ~/.linuxConfig/wallpaperengine/betterlockscreen ~/.config
sudo cp -f ~/.linuxConfig/custom-services/betterlockscreen@.service /usr/lib/systemd/system/
xset +dpms
# 电源时间
xset dpms 1200 1800 2400
# 屏保时间
xset s 900 900
sudo systemctl enable betterlockscreen@$USER
# 语言
ln -sf ~/.linuxConfig/configs/xprofile ~/.xprofile
# 输入法
rm -rf ~/.config/fcitx
rm -rf ~/.config/fcitx5
ln -sf ~/.linuxConfig/fcitxs-config/fcitx ~/.config
ln -sf ~/.linuxConfig/fcitxs-config/fcitx5 ~/.config
# 判断有没有touchpad
if [[ $(xinput list | grep "[tT]ouchpad" -c) != 0 ]]; then
    # 配置触摸板
    if [[ ! -d /etc/X11/xorg.conf.d ]]; then
        sudo mkdir -p /etc/X11/xorg.conf.d
    fi
    sudo cp -f ~/.linuxConfig/configs/20-touchpad.conf /etc/X11/xorg.conf.d/20-touchpad.conf
fi
# sddm
[[ -d /etc/sddm.conf.d ]] || sudo mkdir -p /etc/sddm.conf.d
if [[ -f /etc/sddm.conf.d/kde_settings.conf ]]; then
    echo '已有sddm配置'
else
    sudo cp ~/.linuxConfig/configs/sddm.conf /etc/sddm.conf.d/kde_settings.conf
fi
# obs
[[ -d ~/.config/obs-studio ]] || mkdir ~/.config/obs-studio
[[ -d ~/Videos/obs ]] || mkdir -p ~/Videos/obs
# 自启动程序
