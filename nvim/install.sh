#!/bin/bash

export ALL_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890

pacMan='pacman -S --needed --noconfirm'
aurPkg='yay -S --needed --noconfirm'

sudo "$pacMan" ranger fzf ripgrep fd lldb translate-shell \
    jdk17-openjdk go cmake \
    neovim luarocks shellcheck \
    zathura zathura-djvu zathura-pdf-mupdf zathura-ps zathura-ps \
    typst deno

$aurPkg rust-lolcat-git

sudo "$pacMan" python3 python-pip python-pynvim python-pipenv python-pylsp-rope neovim-remote frogmouth python-neovim

sudo "$pacMan" rustup
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
rustup install stable beta nightly
rustup component add rust-analyzer clippy rustfmt llvm-tools-preview --toolchain stable
rustup component add rust-analyzer clippy rustfmt llvm-tools-preview --toolchain nightly
rustup component add rust-analyzer clippy rustfmt llvm-tools-preview --toolchain beta
rustup default stable
# 切换 crates 源
cargo install crm
~/.cargo/bin/crm best
# `cargo install-update -h`,neotest-rust  用到
cargo install cargo-update cargo-nextest grcov
# criterion benchmark 会用
sudo "$pacMan" gnuplot

# rust 交叉编译
# rustup target add x86_64-pc-windows-gnu
# rustup toolchain install stable-x86_64-pc-windows-gnu
# $pacMan mingw-w64-gcc

$aurPkg powershell-lts-bin

# $aurPkg libldap24 mssql-scripter

$aurPkg rime-ls rime-essay

sudo "$pacMan" texlive-core texlive-bin

# nodejs
sudo "$pacMan" fnm npm
fnm install 18
fnm install 16
fnm default 18

sudo npm i -g neovim npm-check-updates

# sudo npm install --save-dev --save-exact prettier

# 安装插件
if [[ ! -d ~/.local/share/vim/dein/repos/github.com/Shougo/dein.vim ]]; then
    git clone https://github.com/Shougo/dein.vim ~/.local/share/vim/dein/repos/github.com/Shougo/dein.vim
fi

vim -i NONE -c "call dein#install()" -c "qa"

# 给lldb配置runInTerminal
echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

if [[ $(grep -c mason /etc/profile) == 0 ]]; then
    # shellcheck disable=2016
    echo '
export PATH=$PATH:~/.local/share/nvim/mason/bin
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
    ' | sudo tee -a /etc/profile

    source /etc/profile
fi

unset pacMan aurPkg
