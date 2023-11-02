#!/bin/bash

name=term

# 判断有没有这个特殊工作区
if [[ $(hyprctl workspaces | grep -c special:"$name") == 1 ]]; then
    hyprctl dispatch togglespecialworkspace $name
else
    hyprctl dispatch exec \[workspace special:$name \;float\;size 70% 70%\;center\] kitty #&&
    # hyprctl dispatch togglespecialworkspace $name
fi
