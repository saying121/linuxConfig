#!/usr/bin/env bash

# export ALL_PROXY=http://127.0.0.1:7897
# export HTTPS_PROXY=http://127.0.0.1:7897
# export HTTP_PROXY=http://127.0.0.1:7897

pacMan='sudo pacman -S --needed --noconfirm'
aurPkg='yay -S --needed --noconfirm'

# $pacMan neovim
$pacMan fzf ripgrep fd lldb translate-shell \
    jdk17-openjdk jdk21-openjdk go cmake \
    luarocks shellcheck \
    zathura zathura-djvu zathura-ps zathura-ps \
    typst deno tesseract actionlint \
    mold lld sccache silicon tree-sitter-cli
# zathura-pdf-mupdf
$pacMan ruff-lsp vim-language-server lua-language-server bash-language-server \
    gopls yaml-language-server typescript-language-server jdtls gradle marksman \
    texlab typst-lsp revive tidy platformio-core platformio-core-udev biome shfmt \
    lemminx kotlin-language-server cmake-language-server tinymist tailwindcss-language-server

npm install -g awk-language-server vscode-langservers-extracted dot-language-server @olrtg/emmet-language-server \
    awk-language-server @vtsls/language-server
go install github.com/docker/docker-language-server/cmd/docker-language-server@latest

$aurPkg basedpyright-git termux-language-server

$pacMan cargo-flamegraph cargo-binstall cargo-audit cargo-machete cargo-update \
    cargo-nextest grcov cargo-llvm-cov

$aurPkg golines
$pacMan sqlfluff vint
$pacMan prettier stylua
$pacMan python-debugpy delve codelldb-bin

$aurPkg rust-lolcat-git inferno
$aurPkg lf

treesitters=("c" "lua" "bash" "query" "vimdoc" "python" "markdown")
for lang in "${treesitters[@]}"; do
    $pacMan tree-sitter-"$lang"
done

$pacMan python3 python-pip python-pynvim python-pipenv neovim-remote frogmouth python-neovim
$aurPkg python-lsp-server python-pylsp-mypy python-rope python-mccabe python-pylsp-rope
# python-*-stubs

$pacMan rustup
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
~/.linuxConfig/nvim/rust.sh
# criterion benchmark 会用
$pacMan gnuplot

$pacMan perf
cargo binstall -y flamegraph

if [[ $(grep -c "osx-ndk-x86" /etc/profile) == 0 ]]; then
    # shellcheck disable=2016
    echo '
export PATH=$PATH:/usr/local/osx-ndk-x86/bin
' | sudo tee -a /etc/profile

    source /etc/profile
fi

# $aurPkg powershell-lts-bin

# $aurPkg libldap24 mssql-scripter

# $aurPkg rime-ls rime-essay

$pacMan texlive-basic texlive-bin

# nodejs
$pacMan mise npm
mise i node
mise use -g node

sudo npm i -g neovim npm-check-updates

# 安装插件
# if [[ ! -d ~/.local/share/vim/dein/repos/github.com/Shougo/dein.vim ]]; then
#     git clone https://github.com/Shougo/dein.vim ~/.local/share/vim/dein/repos/github.com/Shougo/dein.vim
# fi
# vim -i NONE -c "call dein#install()" -c "qa"
# vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"

# 给lldb配置runInTerminal
# echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
# export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
