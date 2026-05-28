#!/usr/bin/env bash

VIM_FILENAME=$1
NEOVIM="nvim/lua"

if [[ $PWD == *$NEOVIM* ]]; then
    echo "use neovim for Lua script runner"
    printf "\e[1;36m<<<<<<<<<==========================>>>>>>>>>\e[0m\n\n"
    "$HOME"/.config/nvim/tasks/make_color.sh nvim -l "$VIM_FILENAME"
else
    "$HOME"/.config/nvim/tasks/make_color.sh luajit "$VIM_FILENAME"
fi
