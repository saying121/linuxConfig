#!/usr/bin/env bash

[ -d build_go ] || mkdir build_go

VIM_FILENOEXT=$1
VIM_FILENAME=$2

"$HOME"/.config/nvim/tasks/make_color.sh go build -o ./build_go/"$VIM_FILENOEXT" ./"$VIM_FILENAME"
