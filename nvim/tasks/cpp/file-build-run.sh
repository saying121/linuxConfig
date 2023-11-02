#!/bin/bash

[ -d build_c_cpp ] || mkdir build_c_cpp

VIM_FILEPATH=$1
VIM_FILEDIR=$2
VIM_FILENOEXT=$3

# g++
compiler=clang++

"$HOME"/.config/nvim/tasks/make_color.sh $compiler -O2 "$VIM_FILEPATH" -o "$VIM_FILEDIR"/build_c_cpp/"$VIM_FILENOEXT" &&
"$HOME"/.config/nvim/tasks/split_line.sh &&
"$HOME"/.config/nvim/tasks/make_color.sh "$VIM_FILEDIR"/build_c_cpp/"$VIM_FILENOEXT"
