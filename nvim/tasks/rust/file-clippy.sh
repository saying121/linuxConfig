#!/bin/bash

VIM_FILENAME=$1
VIM_FILENOEXT=$2

# 文件名有可能有特殊字符，做了处理
"$HOME"/.config/nvim/tasks/make_color.sh clippy-driver \
    --crate-name "$(rev <<<"$VIM_FILENAME" | cut -d '.' -f 2- | rev | tr '.' '_' | tr '-' '__')" \
    "$VIM_FILENAME"

# 有时候 clippy-driver 生成一个没有后缀的可执行文件
[[ -x ./$VIM_FILENOEXT ]] && rm ./"$VIM_FILENOEXT"
