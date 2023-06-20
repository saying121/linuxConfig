#!/bin/bash

echo -e "\e[1;33m

******************************************************
**** 会取代现有配置，输入no跳过                   ****
**** 非全新安装，建议跳过，会尝试取代现有配置     ****
**** 配置为目录会被备份，配置为文件存在就不会覆盖 ****
**** yes/no                                       ****
******************************************************
\e[0m
"

read -r answer
if [[ ! $answer = yes ]]; then
    exit 0
fi

# 环境变量
if [[ $(grep -c PROXY /etc/profile) == 0 ]]; then
    # shellcheck disable=2016
    echo '
export ALL_PROXY=http://127.0.0.1:7890 export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890
export NO_PROXY=baidu.com,qq.com

export EDITOR=nvim

export PATH=~/go/bin:$PATH
export PATH=~/.cargo/bin:~/.local/bin:$PATH
export GOPATH=~/go
export PATH=/usr/lib/w3m:$PATH

export XDG_DATA_HOME=~/.local/share
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache

export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_QPA_PLATFORM="wayland;xcb"
export QT_QPA_PLATFORMTHEME=qt5ct # 外观用qt5ct设置
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

# java程序黑屏
export _JAVA_AWT_WM_NONEREPARENTING=1

# 游戏
export SDL_VIDEODRIVER=wayland
# gtk 优先wayland
export GDK_BACKEND="wayland,x11"

    ' | sudo tee -a /etc/profile

    source /etc/profile
fi

declare -A link_list
link_list=(
    ["$HOME/.linuxConfig/.pip"]="$HOME/"
    ["$HOME/.linuxConfig/X11/Xresources"]="$HOME/.Xresources"
    ["$HOME/.linuxConfig/X11/xinitrc"]="$HOME/.xinitrc"
    ["$HOME/.linuxConfig/X11/xprofile"]="$HOME/.xprofile"
    ["$HOME/.linuxConfig/configs/flameshot.ini"]="$HOME/.config/flameshot/flameshot.ini"
    ["$HOME/.linuxConfig/configs/go-musicfox.ini"]="$HOME/.go-musicfox/go-musicfox.ini"
    ["$HOME/.linuxConfig/configs/konsave-conf.yaml"]="$HOME/.config/konsave/conf.yaml"
    ["$HOME/.linuxConfig/configs/leetcode.toml"]="$HOME/.leetcode/leetcode.toml"
    ["$HOME/.linuxConfig/configs/npmrc"]="$HOME/.npmrc"
    ["$HOME/.linuxConfig/configs/rime-ls-user.yaml"]="$HOME/.local/share/rime-ls-nvim/user.yaml"
    ["$HOME/.linuxConfig/configs/tldrrc"]="$HOME/.tldrrc"
    ["$HOME/.linuxConfig/configs/w3m-config"]="$HOME/.w3m/config"
    ["$HOME/.linuxConfig/fcitxs-config/fcitx"]="$HOME/.config"
    ["$HOME/.linuxConfig/fcitxs-config/fcitx5"]="$HOME/.config"
    ["$HOME/.linuxConfig/formatters/clang-format"]="$HOME/.clang-format"
    ["$HOME/.linuxConfig/formatters/prettierrc.json"]="$HOME/.prettierrc.json"
    ["$HOME/.linuxConfig/formatters/stylua"]="$HOME/.config"
    ["$HOME/.linuxConfig/fusuma"]="$HOME/.config"
    ["$HOME/.linuxConfig/gitui"]="$HOME/.config"
    ["$HOME/.linuxConfig/i3"]="$HOME/.config"
    ["$HOME/.linuxConfig/i3/i3status-rust"]="$HOME/.config"
    ["$HOME/.linuxConfig/input-remapper-2"]="$HOME/.config"
    ["$HOME/.linuxConfig/kitty"]="$HOME/.config"
    ["$HOME/.linuxConfig/lf"]="$HOME/.config"
    ["$HOME/.linuxConfig/lf/ctpv"]="$HOME/.config"
    ["$HOME/.linuxConfig/nvim"]="$HOME/.config"
    ["$HOME/.linuxConfig/nvim/coc-config/coc-settings.json"]="$HOME/.vim/coc-settings.json"
    ["$HOME/.linuxConfig/nvim/tasks.ini"]="$HOME/.vim/tasks.ini"
    ["$HOME/.linuxConfig/nvim/viml/init.vim"]="$HOME/.vimrc"
    ["$HOME/.linuxConfig/qt5ct"]="$HOME/.config"
    ["$HOME/.linuxConfig/ranger"]="$HOME/.config"
    ["$HOME/.linuxConfig/shells/bashrc"]="$HOME/.bashrc"
    ["$HOME/.linuxConfig/shells/lib/lessfilter.sh"]="$HOME/.lessfilter"
    ["$HOME/.linuxConfig/shells/lib/p10k.zsh"]="$HOME/.p10k.zsh"
    ["$HOME/.linuxConfig/shells/starship.toml"]="$HOME/.config/starship.toml"
    ["$HOME/.linuxConfig/shells/zirc.zsh"]="$HOME/.zshrc"
    ["$HOME/.linuxConfig/terminology"]="$HOME/.config"
    ["$HOME/.linuxConfig/wallpaperengine/betterlockscreen"]="$HOME/.config"
    ["$HOME/.linuxConfig/wayland/hypr"]="$HOME/.config"
    ["$HOME/.linuxConfig/wayland/swaylock"]="$HOME/.config"
    ["$HOME/.linuxConfig/wayland/waybar"]="$HOME/.config"
    ["$HOME/.linuxConfig/wezterm"]="$HOME/.config"
)

# 和创建必要的目录
[[ -d ~/.config ]] || mkdir ~/.config
[[ -d ~/.config/flameshot ]] || mkdir -p ~/.config/flameshot
[[ -d ~/.config/konsave ]] || mkdir -p ~/.config/konsave
[[ -d ~/.go-musicfox ]] || mkdir ~/.go-musicfox
[[ -d ~/.leetcode ]] || mkdir ~/.leetcode
[[ -d ~/.local/share/rime-ls-nvim ]] || mkdir -p ~/.local/share/rime-ls-nvim
[[ -d ~/.local/shells ]] || mkdir -p ~/.local/shells
[[ -d ~/.vim ]] || mkdir ~/.vim
[[ -d ~/.w3m ]] || mkdir ~/.w3m

# keymap 路径带有空格就单拎出来
path="$HOME/.config/input-remapper-2"
if [[ -d $path && ! -L $path ]]; then
    mv "$path" "$path""_bak"
fi

for path in "${!link_list[@]}"; do
    # 配置为目录会被备份
    be_back=$(echo "$path" | awk -F / '{print $NF}')
    be_back_path=${link_list[$path]}/$be_back

    if [[ -d $be_back_path && ! -L $be_back_path ]]; then
        if [[ -d $be_back_path"_bak" ]]; then
            continue
        fi
        mv "$be_back_path" "$be_back_path""_bak"
    else
        ln -sf "$path" "${link_list[$path]}"
        continue
    fi

    # 存在为软连接的配置就强制覆盖，否则尝试链接
    if [[ -L ${link_list[$path]} ]]; then
        ln -sf "$path" "${link_list[$path]}"
    else
        ln -s "$path" "${link_list[$path]}"
    fi
done

sudo sed -i 's/^#HibernateDelaySec=.*/HibernateDelaySec=3600/' /etc/systemd/sleep.conf

[[ -d ~/.config/systemd/user ]] || mkdir -p ~/.config/systemd/user

if [[ $XDG_SESSION_TYPE == wayland ]]; then
    the_cmd="libinput list-devices"
else
    the_cmd="xinput list"
fi
# 判断有没有 touchpad
if [[ $($the_cmd | grep "[tT]ouchpad" -c) != 0 ]]; then
    # 配置触摸板
    if [[ ! -d /etc/X11/xorg.conf.d ]]; then
        sudo mkdir -p /etc/X11/xorg.conf.d
    fi
    sudo cp -f ~/.linuxConfig/X11/20-touchpad.conf /etc/X11/xorg.conf.d/20-touchpad.conf
fi
