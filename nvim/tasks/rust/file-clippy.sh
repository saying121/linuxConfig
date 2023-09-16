#!/bin/bash

[ -d build_rust ] || mkdir build_rust

VIM_FILENAME=$1

# 文件名有可能有特殊字符，做了处理
"$HOME/.config/nvim/tasks/make_color.sh" clippy-driver \
    --crate-name "$(rev <<<"$VIM_FILENAME" | cut -d '.' -f 2- | rev | tr '.' '_' | tr '-' '__')" \
    "$VIM_FILENAME"
