#!/usr/bin/env bash

## Available Styles
#
## style-1     style-2     style-3     style-4     style-5

dir="$HOME/.config/rofi/launchers/type-6"
theme='style-7'
thepath=$dir/$theme.rasi

# 解除验证限制
xhost + >/dev/null

# PATH=$PATH
pkexec env DISPLAY="$DISPLAY" XAUTHORITY="$XAUTHORITY" XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" \
    rofi -show drun -theme "$thepath"
