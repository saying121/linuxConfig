#!/usr/bin/env bash

VIM_FILEDIR=$1
VIM_FILENOEXT=$2

"$HOME"/.config/nvim/tasks/make_color.sh "$VIM_FILEDIR"/build_c_cpp/"$VIM_FILENOEXT"
