#!/bin/bash

[ -d build_go ] || mkdir build_go

VIM_FILEDIR=$1
VIM_FILENOEXT=$2

"$HOME"/.config/nvim/tasks/make_color.sh go build -o "$VIM_FILEDIR"/build_go/"$VIM_FILENOEXT"
