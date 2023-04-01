#!/bin/bash

sh -c "$(curl -fsSL get.zshell.dev)" --

pacMan="pacman -S --needed --noconfirm"
sudo $pacMan pkgfile python3 \
    subversion lesspipe fastjar unrtf lesspipe catdoc id3v2
unset pacMan
sudo pkgfile -u
pkgfile makepkg

ln -sf ~/.linuxConfig/shells/zirc.zsh ~/.zshrc

pip install thefuck

[[ -d ~/.zi/cache ]] || mkdir ~/.zi/cache

curl https://raw.githubusercontent.com/LuRsT/hr/master/hr > ~/.local/bin/hr
chmod +x ~/.local/bin/hr
