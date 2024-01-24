#!/usr/bin/env bash

VIM_ROOT=$1

if [[ -f $VIM_ROOT/build.rs ]]; then
    "$HOME"/.config/nvim/tasks/make_color.sh cargo run -vv
else
    "$HOME"/.config/nvim/tasks/make_color.sh cargo run
fi
