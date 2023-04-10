#!/bin/bash

echo "
**************************************************
**** 会取代现有配置，输入no跳过               ****
**** 非全新安装，建议跳过，会尝试取代现有配置 ****
**** yes/no                                   ****
**************************************************
"

read -r answer
if [[ ! $answer = yes ]]; then
	exit 0
fi


# 环境变量
if [[ $(grep -c PROXY /etc/profile) == 0 ]]; then
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

export PATH=~/go/bin:$PATH
export GOPATH=~/go
export PATH=/usr/lib/w3m:$PATH

export XDG_DATA_HOME=~/.local/share
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
    ' | sudo tee -a /etc/profile

    source /etc/profile
fi

[[ -d ~/.config ]] || mkdir ~/.config
[[ -d ~/.config/systemd/user ]] || mkdir -p ~/.config/systemd/user
# dex 设置自启动应用
cp ~/.linuxConfig/custom-services/autostart.service ~/.config/systemd/user
cp ~/.linuxConfig/custom-services/autostart.target ~/.config/systemd/user
sudo systemctl --user daemon-reload
sudo systemctl --user enable autostart.service

# gitui
mv ~/.config/gitui ~/.config/gitui_bak
ln -s ~/.linuxConfig/gitui ~/.config
# qt5ct
mv ~/.config/qt5ct ~/.config/qt5ct_bak
ln -s ~/.linuxConfig/qt5ct ~/.config
# clang-format
ln -s ~/.linuxConfig/formatters/clang-format ~/.clang-format
mv ~/.prettierrc.json ~.prettierrc.bak
ln -s ~/.linuxConfig/formatters/prettierrc.json  ~/.prettierrc.json
# stylua
ln -s ~/.linuxConfig/formatters/stylua ~/.config
# w3m
[[ -d ~/.w3m ]] || mkdir ~/.w3m
ln -s ~/.linuxConfig/configs/w3m-config ~/.w3m/config
# pip
mv ~/.pip ~/.pip_bak
ln -s ~/.linuxConfig/.pip ~/
# nvim
mv ~/.config/nvim ~/.config/nvim_bak
ln -s ~/.linuxConfig/nvim ~/.config
[[ -d ~/.local/share/rime-ls-nvim ]] || mkdir ~/.local/share/rime-ls-nvim
ln -s ~/.linuxConfig/configs/rime-ls-user.yaml ~/.local/share/rime-ls-nvim/user.yaml
[[ -d ~/.vim ]] || mkdir ~/.vim
ln -s ~/.linuxConfig/nvim/tasks.ini ~/.vim/tasks.ini
# vim
ln -s ~/.linuxConfig/nvim/viml/init.vim ~/.vimrc
# coc
ln -s ~/.linuxConfig/nvim/coc-config/coc-settings.json ~/.vim/coc-settings.json

# # zshrc
# ln -s ~/.linuxConfig/shells/.zshrc ~/.zshrc
# bashrc
ln -s ~/.linuxConfig/shells/bashrc ~/.bashrc
[[ -d ~/.local/shells ]] || mkdir ~/.local/shells
# ranger
mv ~/.config/ranger ~/.config/ranger_bak
ln -s ~/.linuxConfig/ranger ~/.config
# lf
mv ~/.config/lf ~/.config/lf_bak
ln -s ~/.linuxConfig/lf ~/.config
# tldr
ln -s ~/.linuxConfig/configs/tldrrc ~/.tldrrc
# npm
ln -s ~/.linuxConfig/configs/npmrc ~/.npmrc
# music
[[ -d ~/.go-musicfox ]] || mkdir ~/.go-musicfox
ln -s ~/.linuxConfig/configs/go-musicfox.ini ~/.go-musicfox/go-musicfox.ini
# leetcode-cli
[[ -d ~/.leetcode ]] || mkdir ~/.leetcode
ln -s ~/.linuxConfig/configs/leetcode.toml ~/.leetcode/leetcode.toml

# flameshot
[[ -d ~/.config/flameshot ]] || mkdir -p ~/.config/flameshot
ln -s ~/.linuxConfig/configs/flameshot.ini ~/.config/flameshot/flameshot.ini
# kitty
mv ~/.config/kitty ~/.config/kitty_bak
ln -s ~/.linuxConfig/kitty ~/.config
# wezterm
mv ~/.config/wezterm ~/.config/wezterm_bak
ln -s ~/.linuxConfig/wezterm ~/.config
# terminology
mv ~/.config/terminology ~/.config/terminology_bak
ln -s ~/.linuxConfig/terminology ~/.config
# konsave config
[[ -d ~/.config/konsave ]] || mkdir -p ~/.config/konsave
ln -s ~/.linuxConfig/configs/konsave-conf.yaml ~/.config/konsave/conf.yaml
# 触摸板手势
mv ~/.config/fusuma ~/.config/fusuma_bak
ln -s ~/.linuxConfig/fusuma ~/.config
# i3
ln -s ~/.linuxConfig/i3 ~/.config
ln -s ~/.linuxConfig/i3/i3status-rust ~/.config
ln -s ~/.linuxConfig/wallpaperengine/betterlockscreen ~/.config
sudo cp -f ~/.linuxConfig/custom-services/betterlockscreen@.service /usr/lib/systemd/system/
# 语言
ln -s ~/.linuxConfig/configs/xprofile ~/.xprofile
# xinit
ln -s ~/.linuxConfig/configs/xinitrc ~/.xinitrc
# 输入法
mv ~/.config/fcitx ~/.config/fcitx_bak
mvn ~/.config/fcitx5 ~/.config/fcitx5_bak
ln -s ~/.linuxConfig/fcitxs-config/fcitx ~/.config
ln -s ~/.linuxConfig/fcitxs-config/fcitx5 ~/.config
# 判断有没有 touchpad
if [[ $(xinput list | grep "[tT]ouchpad" -c) != 0 ]]; then
    # 配置触摸板
    if [[ ! -d /etc/X11/xorg.conf.d ]]; then
        sudo mkdir -p /etc/X11/xorg.conf.d
    fi
    sudo cp -f ~/.linuxConfig/configs/20-touchpad.conf /etc/X11/xorg.conf.d/20-touchpad.conf
fi
# sddm
[[ -d /etc/sddm.conf.d ]] || sudo mkdir -p /etc/sddm.conf.d
sudo cp ~/.linuxConfig/configs/sddm.conf /etc/sddm.conf.d/kde_settings.conf
sudo cp ~/.linuxConfig/configs/kde_setting.conf /etc/sddm.conf.d/kde_settings.conf
# obs
[[ -d ~/.config/obs-studio ]] || mkdir ~/.config/obs-studio
[[ -d ~/Videos/obs ]] || mkdir -p ~/Videos/obs
# keymap
mv ~/.config/input-remapper ~/.config/input-remapper_bak
ln -s ~/.linuxConfig/input-remapper ~/.config
[[ -d ~/.linuxConfig/input-remapper/presets/Keyboard\ K380\ Keyboard/ ]] || mkdir ~/.linuxConfig/input-remapper/presets/Keyboard\ K380\ Keyboard/
ln -s ~/.linuxConfig/input-remapper/presets/AT\ Translated\ Set\ 2\ keyboard/capslock+.json ~/.linuxConfig/input-remapper/presets/Keyboard\ K380\ Keyboard/capslock+.json
[[ -d ~/.linuxConfig/input-remapper/presets/SINO\ WEALTH\ Gaming\ KB\ / ]] || mkdir ~/.linuxConfig/input-remapper/presets/SINO\ WEALTH\ Gaming\ KB\ /
ln -s ~/.linuxConfig/input-remapper/presets/AT\ Translated\ Set\ 2\ keyboard/capslock+.json ~/.linuxConfig/input-remapper/presets/SINO\ WEALTH\ Gaming\ KB\ /capslock+.json
