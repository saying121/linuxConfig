#!/usr/bin/env bash

build_dir='build_c_cpp'

[ -d $build_dir ] || mkdir $build_dir

VIM_FILEPATH=$1

compiler=gcc

if which gcc-14 >/dev/null; then
    compiler=gcc-14
fi

$compiler -fanalyzer "$VIM_FILEPATH"
