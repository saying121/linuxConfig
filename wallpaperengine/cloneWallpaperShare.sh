#!/bin/bash

rm -rf ~/.local/share/wallpaperengine

mkdir ~/.local/share/wallpaperengine

cd ~/.local/share/wallpaperengine || exit

git init

git remote add -f origin https://github.com/Almamu/linux-wallpaperengine.git

git config core.sparsecheckout true

echo "share" >>.git/info/sparse-checkout

git checkout main

if [[ $(grep -c arch /etc/os-release) != 0 ]]; then
    yay -S linux-wallpaperengine-git
fi

if [[ ! -d ~/.config/systemd/user ]]; then
    mkdir -p ~/.config/systemd/user
fi
if [[ ! -f ~/.config/systemd/user/wallpaper.service ]]; then
    cp -f ~/.linuxConfig/custom-services/wallpaperengine.service ~/.config/systemd/user/wallpaperengine.service
    # 脚本的绝对路径
    sed -i.bak "s#ExecStart=.*/.linuxConfig/wallpaperengine/wallpaper.sh#ExecStart=$HOME/.linuxConfig/wallpaperengine/wallpaper.sh#" ~/.config/systemd/user/wallpaperengine.service
    systemctl --user daemon-reload
    # 好像只能通过其他方式自启动
    # systemctl --user enable wallpaperengine.service
fi

ln -sf ~/.linuxConfig/wallpaperengine/rewall.sh ~/.local/bin/rewall

# cd ~/.local/share/wallpaperengine
# git pull
