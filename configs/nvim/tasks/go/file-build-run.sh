#!/usr/bin/env bash

[ -d build_go ] || mkdir build_go

VIM_FILENAME=$1
VIM_FILEDIR=$2
VIM_FILENOEXT=$3

"$HOME/.config/nvim/tasks/make_color.sh" go build -o ./build_go/"$VIM_FILENOEXT"  ./"$VIM_FILENAME"&&
"$HOME/.config/nvim/tasks/split_line.sh" &&
"$HOME/.config/nvim/tasks/make_color.sh" "$VIM_FILEDIR"/build_go/"$VIM_FILENOEXT"
