#!/usr/bin/env bash

class="rangeterm"
animation="fade"
termianl="kitty --class"
# termianl="wezterm start --class"

slurp -d -b "#00000000" -c "#FFC0CBFF" -s "#00000044" -f "
hyprctl keyword windowrule unset, $class
hyprctl keyword windowrule animation $animation, $class
hyprctl keyword windowrule move %x %y, $class
hyprctl keyword windowrule float, $class
hyprctl keyword windowrule size %w %h, $class
$termianl $class" | bash
