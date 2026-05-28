#!/usr/bin/env bash

build_dir=build_c_cpp
[ -d $build_dir ] || mkdir $build_dir

VIM_FILEPATH=$1
VIM_FILEDIR=$2
VIM_FILENOEXT=$3

# compiler="nasm"
compiler="yasm"
bits="elf64"

outfile="$VIM_FILEDIR"/"$build_dir"/"$VIM_FILENOEXT"
outfile_o="$VIM_FILEDIR"/$build_dir/"$VIM_FILENOEXT".o

"$HOME"/.config/nvim/tasks/make_color.sh $compiler -f $bits "$VIM_FILEPATH" -o "$outfile_o" &&
    mold "$outfile_o" -o "$outfile"
