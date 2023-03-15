#!/bin/bash

rm -rf ~/.local/share/wallpaperengine

mkdir ~/.local/share/wallpaperengine

cd ~/.local/share/wallpaperengine

git init

git remote add -f origin https://github.com/Almamu/linux-wallpaperengine.git

git config core.sparsecheckout true

echo "share" >>.git/info/sparse-checkout

git checkout main

yay -S linux-wallpaperengine-git

if [[ ! -d ~/.config/systemd/user ]]; then
	mkdir -p ~/.config/systemd/user
fi
if [[ ! -f ~/.config/systemd/user/wallpaper.service ]]; then
    cp ~/.linuxConfig/custom-services/wallpaper.service ~/.config/systemd/user/wallpaper.service

    sudo systemctl daemon-reload
    systemctl --user enable wallpaper.service
fi

# cd ~/.local/share/wallpaperengine
# git pull
