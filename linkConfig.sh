#!/usr/bin/env bash

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
if [[ $(grep -c EDITOR /etc/profile) == 0 ]]; then
    # shellcheck disable=2016
    echo '
export XDG_DATA_HOME=~/.local/share
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache

export EDITOR=nvim

export PATH=$PATH:~/.cargo/bin:~/.local/bin:~/go/bin
export GOPATH=$XDG_DATA_HOME/go
export GOBIN=$XDG_DATA_HOME/go/bin
export PATH=$PATH:/usr/lib/w3m

export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_QPA_PLATFORM="wayland;xcb"
export QT_QPA_PLATFORMTHEME=qt5ct # 外观用 qt5ct 设置
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
dot_dir=$(git rev-parse --show-toplevel)
link_list=(
    ["$dot_dir/configs/kitty"]="$HOME/.config"
    ["$dot_dir/configs/lf"]="$HOME/.config"
    ["$dot_dir/configs/lf/ctpv"]="$HOME/.config"
    ["$dot_dir/configs/microsoft-edge-stable-flags.conf"]="$HOME/.config"
    ["$dot_dir/configs/aerospace"]="$HOME/.config"
    ["$dot_dir/configs/aerospace/borders"]="$HOME/.config"
    ["$dot_dir/configs/fcitxs-config/fcitx5"]="$HOME/.config"
    ["$dot_dir/configs/flameshot"]="$HOME/.config"
    ["$dot_dir/configs/gitui"]="$HOME/.config"
    ["$dot_dir/configs/terminology"]="$HOME/.config"
    ["$dot_dir/configs/wezterm"]="$HOME/.config"
    ["$dot_dir/configs/yazi"]="$HOME/.config"
    ["$dot_dir/formatters/rustfmt"]="$HOME/.config"
    ["$dot_dir/formatters/stylua"]="$HOME/.config"
    ["$dot_dir/i3"]="$HOME/.config"
    ["$dot_dir/i3/i3status-rust"]="$HOME/.config"
    ["$dot_dir/nvim"]="$HOME/.config"
    ["$dot_dir/qt5ct"]="$HOME/.config"
    ["$dot_dir/wallpaperengine/betterlockscreen"]="$HOME/.config"
    ["$dot_dir/wayland/hypr"]="$HOME/.config"
    ["$dot_dir/wayland/swaylock"]="$HOME/.config"
    ["$dot_dir/wayland/waybar"]="$HOME/.config"

    ["$dot_dir/configs/npmrc"]="$HOME/.npmrc"
    ["$dot_dir/configs/taplo.toml"]="$HOME/.taplo.toml"
    ["$dot_dir/configs/tldrrc"]="$HOME/.tldrrc"
    ["$dot_dir/nvim/viml/init.vim"]="$HOME/.vimrc"
    ["$dot_dir/shells/bashrc"]="$HOME/.bashrc"
    ["$dot_dir/X11/Xresources"]="$HOME/.Xresources"
    ["$dot_dir/X11/xinitrc"]="$HOME/.xinitrc"
    ["$dot_dir/X11/xprofile"]="$HOME/.xprofile"
    ["$dot_dir/configs/festivalrc"]="$HOME/.festivalrc"
    ["$dot_dir/configs/gtkrc-2.0"]="$HOME/.gtkrc-2.0"
    ["$dot_dir/configs/lessfilter.sh"]="$HOME/.lessfilter"
    ["$dot_dir/shells/zirc.zsh"]="$HOME/.zshrc"
    ["$dot_dir/formatters/clang-format"]="$HOME/.clang-format"
    ["$dot_dir/formatters/prettierrc.json"]="$HOME/.prettierrc.json"

    ["$dot_dir/.pip"]="$HOME/"

    ["$dot_dir/configs/cargo-config.toml"]="$HOME/.cargo/config.toml"

    ["$dot_dir/configs/go-musicfox.ini"]="$HOME/.config/go-musicfox/go-musicfox.ini"

    ["$dot_dir/configs/mimeapps.list"]="$HOME/.config/mimeapps.list"
    ["$dot_dir/shells/starship.toml"]="$HOME/.config/starship.toml"

    ["$dot_dir/configs/rime-ls-user.yaml"]="$HOME/.local/share/rime-ls-nvim/user.yaml"
    ["$dot_dir/configs/w3m-config"]="$HOME/.w3m/config"
    ["$dot_dir/nvim/coc-config/coc-settings.json"]="$HOME/.vim/coc-settings.json"
    ["$dot_dir/nvim/tasks.ini"]="$HOME/.vim/tasks.ini"
)

# 创建必要的目录
[[ -d ~/.config/go-musicfox ]] || mkdir ~/.config/go-musicfox
[[ -d ~/.config ]] || mkdir ~/.config
[[ -d ~/.local/share/rime-ls-nvim ]] || mkdir -p ~/.local/share/rime-ls-nvim
[[ -d ~/.local/shells ]] || mkdir -p ~/.local/shells
[[ -d ~/.vim ]] || mkdir ~/.vim
[[ -d ~/.w3m ]] || mkdir ~/.w3m

for source_path in "${!link_list[@]}"; do
    dst_path_or_link=${link_list[$source_path]}
    # 配置为目录会被备份
    be_back=$(echo "$source_path" | awk -F / '{print $NF}')
    be_back_path=$dst_path_or_link/$be_back

    # 如果有要备份的目录，而且不是软连接
    if [[ -d $be_back_path && ! -L $be_back_path ]]; then
        # 如果已经备份
        if [[ -d $be_back_path"_bak" ]]; then
            continue
        fi
        mv "$be_back_path" "$be_back_path""_bak"
    # 目录为软连接，或者没有目录
    else
        ln -sf "$source_path" "$dst_path_or_link"
        continue
    fi

    # 存在为软连接的配置就强制覆盖，否则尝试链接
    if [[ -L ${link_list[$source_path]} ]]; then
        ln -sf "$source_path" "$dst_path_or_link"
    else
        ln -s "$source_path" "$dst_path_or_link"
    fi
done

# 两小时后休眠
sudo sed -i.bak 's/^#HibernateDelaySec=.*/HibernateDelaySec=7200/' /etc/systemd/sleep.conf

[[ -d ~/.config/systemd/user ]] || mkdir -p ~/.config/systemd/user

if [[ $XDG_SESSION_TYPE == wayland ]]; then
    the_cmd="sudo libinput list-devices"
else
    the_cmd="sudo xinput list"
fi

# 判断有没有 touchpad
if [[ $($the_cmd | grep "[tT]ouchpad" -c) != 0 ]]; then
    # 配置触摸板
    if [[ ! -d /etc/X11/xorg.conf.d ]]; then
        sudo mkdir -p /etc/X11/xorg.conf.d
    fi
    sudo cp -f ~/.linuxConfig/X11/20-touchpad.conf /etc/X11/xorg.conf.d/20-touchpad.conf
fi
