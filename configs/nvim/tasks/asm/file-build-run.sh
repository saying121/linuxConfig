#!/usr/bin/env bash

build_dir=build_asm

[ -d $build_dir ] || mkdir $build_dir

VIM_FILEPATH=$1
VIM_FILEDIR=$2
VIM_FILENOEXT=$3

# compiler="nasm"
compiler="yasm"
bits="elf"

outfile_o="$VIM_FILEDIR"/$build_dir/"$VIM_FILENOEXT".o
output="$VIM_FILEDIR"/$build_dir/"$VIM_FILENOEXT"

"$HOME"/.config/nvim/tasks/make_color.sh $compiler -f $bits "$VIM_FILEPATH" -o "$outfile_o" &&
    mold "$outfile_o" -o "$output" &&
    "$HOME"/.config/nvim/tasks/split_line.sh &&
    "$HOME"/.config/nvim/tasks/make_color.sh "$output"
