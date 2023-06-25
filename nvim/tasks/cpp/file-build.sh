#!/bin/bash

[ -d build_c_cpp ] || mkdir build_c_cpp

VIM_FILEPATH=$1
VIM_FILEDIR=$2
VIM_FILENOEXT=$3

# g++
compiler=clang++

time $compiler -O2 "$VIM_FILEPATH" -o "$VIM_FILEDIR/build_c_cpp/$VIM_FILENOEXT"
