#!/bin/bash

[ -d build_go ] || mkdir build_go

VIM_FILEDIR=$1
VIM_FILENOEXT=$2

time go build -o "$VIM_FILEDIR/build_go/$VIM_FILENOEXT"
