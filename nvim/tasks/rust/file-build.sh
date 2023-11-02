#!/bin/bash

[ -d build_rust ] || mkdir build_rust

VIM_FILENAME=$1
VIM_FILEDIR=$2
VIM_FILENOEXT=$3

# 文件名有可能有特殊字符，做了处理
"$HOME"/.config/nvim/tasks/make_color.sh rustc -o "$VIM_FILEDIR"/build_rust/"$VIM_FILENOEXT" \
    --crate-name "$(rev <<<"$VIM_FILENAME" | cut -d '.' -f 2- | rev | tr '.' '_' | tr '-' '__')" \
    "$VIM_FILENAME"
