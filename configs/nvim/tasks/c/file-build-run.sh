#!/usr/bin/env bash

build_dir="build_c_cpp"

[ -d $build_dir ] || mkdir $build_dir

VIM_FILEPATH=$1
VIM_FILEDIR=$2
VIM_FILENOEXT=$3

compiler=clang
# compiler=gcc

outfile="$VIM_FILEDIR"/"$build_dir"/"$VIM_FILENOEXT"

"$HOME"/.config/nvim/tasks/make_color.sh $compiler -O2 "$VIM_FILEPATH" -o "$outfile" &&
"$HOME"/.config/nvim/tasks/split_line.sh &&
"$HOME"/.config/nvim/tasks/make_color.sh "$outfile"
