#!/usr/bin/env bash

build_dir='build_c_cpp'

[ -d $build_dir ] || mkdir $build_dir

VIM_FILEPATH=$1
VIM_FILEDIR=$2
VIM_FILENOEXT=$3

# gcc
compiler=clang

outfile="$VIM_FILEDIR"/"$build_dir"/"$VIM_FILENOEXT"

"$HOME"/.config/nvim/tasks/make_color.sh $compiler -O2 "$VIM_FILEPATH" -o "$outfile"
