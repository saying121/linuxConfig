#!/bin/bash

# web-search
if [[ ! -d ~/.oh-my-zsh/custom/plugins/web-search ]]; then
    git clone https://github.com/lesonky/web-search.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/web-search
fi

# git-open
sudo pacman -S --noconfirm npm
sudo npm install --global git-open
if [[ ! -d ~/.oh-my-zsh/custom/plugins/git-open ]]; then
    git clone https://github.com/paulirish/git-open.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/git-open
fi

# fzf-tab
if [[ ! -d ~/.oh-my-zsh/custom/plugins/fzf-tab ]]; then
    git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
fi

if [[ ! -d ~/.oh-my-zsh/custom/plugins/z ]]; then
    git clone https://github.com/skywind3000/z.lua.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/z
fi

# command-not-found
if [[ $(grep -c arch /etc/os-release) != 0 ]]; then
    pacMan="pacman -S --needed --noconfirm"
    sudo $pacMan pkgfile
    unset pacMan
    sudo pkgfile -u
    pkgfile makepkg
fi

if [[ -f ~/.zshrc.pre-oh-my-zsh ]]; then
    rm ~/.zshrc.pre-oh-my-zsh
fi
ln -sf ~/.linuxConfig/shells/.zshrc ~/.zshrc
pip install thefuck
