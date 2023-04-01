#!/bin/bash

export ALL_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890

pacMan=pacman -S --needed --noconfirm

sudo $pacMan ranger fzf python3 python-pip nvm npm lolcat ripgrep fd lldb translate-shell \
    rustup lua-language-server jdk17-openjdk go \
    neovim vale-git luarocks shfmt shellcheck

sudo $pacMan python3 python-pip
pip3 install black isort pynvim pipenv tldr pylsp-rope debugpy vim-vint neovim

rustup install stable beta nightly
rustup component add rust-analyzer clippy rustfmt
# yay -S --noconfirm python-gdbgui

yay -S --noconfirm powershell-lts-bin powershell-editor-services

yay -S --noconfirm libldap24 mssql-scripter

yay -S --noconfirm rime-ls rime-essay

# nodejs
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
source /usr/share/nvm/init-nvm.sh
nvm install v18.13.0
nvm install v16.19.0
nvm alias default v18.13.0

sudo npm i -g neovim npm-check-updates awk-language-server bash-language-server neovim sql-language-server emmet-ls

sudo npm install --save-dev --save-exact prettier

# 安装插件
if [[ ! -d ~/.local/share/nvim/lazy/lazy.nvim ]]; then
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable ~/.local/share/nvim/lazy/lazy.nvim
fi
if [[ ! -d ~/.local/share/vim/dein/repos/github.com/Shougo/dein.vim ]]; then
    git clone https://github.com/Shougo/dein.vim ~/.local/share/vim/dein/repos/github.com/Shougo/dein.vim
fi

vim -i NONE -c "call dein#install()" -c "qa"
nvim "+Lazy! sync" +qa

# 给lldb配置runInTerminal
echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

if [[ $(grep -c mason /etc/profile) == 0 ]]; then
    # shellcheck disable=2016
    echo '
export PATH=$PATH:~/.local/share/nvim/mason/bin
export PATH=~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin:$PATH
    ' | sudo tee -a /etc/profile

    source /etc/profile
fi
