#!/bin/bash

[ -z "$5" ] && echo "Usage $0 <img> x y <max height> <max width>" && exit
# shellcheck disable=1090
source "$(ueberzug library)"

ImageLayer 0< <(
    # shellcheck disable=2102
    ImageLayer::add [identifier]="example0" [x]="$2" [y]="$3" [max_width]="$5" [max_height]="$4" [path]="$1"
    # shellcheck disable=2162
    read
)
