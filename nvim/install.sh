#!/bin/bash

export ALL_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890

pacMan='pacman -S --needed --noconfirm'
aurPkg='yay -S --needed --noconfirm'

sudo $pacMan ranger fzf python3 python-pip fnm npm lolcat ripgrep fd lldb translate-shell \
    rustup jdk17-openjdk go \
    neovim vale-git luarocks shellcheck \
    zathura zathura-djvu zathura-pdf-mupdf zathura-ps zathura-ps \
    typst

sudo $pacMan python3 python-pip
pip3 install black isort pynvim pipenv tldr pylsp-rope debugpy vim-vint neovim neovim-remote

export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
rustup install stable beta nightly
rustup component add rust-analyzer clippy rustfmt --toolchain stable
rustup component add rust-analyzer clippy rustfmt --toolchain nightly
rustup component add rust-analyzer clippy rustfmt --toolchain beta
rustup default stable
# 切换 crates 源
cargo install crm
crm best

# rust 交叉编译
# rustup target add x86_64-pc-windows-gnu
# rustup toolchain install stable-x86_64-pc-windows-gnu
# $pacMan mingw-w64-gcc

$aurPkg powershell-lts-bin # powershell-editor-services

$aurPkg libldap24 mssql-scripter

$aurPkg rime-ls rime-essay

sudo $pacMan texlive-core texlive-bin

# nodejs
fnm install 18
fnm install 16
fnm default 18

sudo npm i -g neovim npm-check-updates neovim

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
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export PATH=~/.cargo/bin:~/.local/bin:$PATH
    ' | sudo tee -a /etc/profile

    source /etc/profile
fi

unset pacMan aurPkg
