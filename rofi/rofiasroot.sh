#!/usr/bin/env bash

## Available Styles
#
## style-1     style-2     style-3     style-4     style-5

dir="$HOME/.config/rofi/launchers/type-6"
theme='style-7'
thepath=$dir/$theme.rasi
echo $thepath

# pkexec env PATH=$PATH DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
    pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
    rofi -show drun -theme $thepath
# ${dir}/${theme}.rasi
