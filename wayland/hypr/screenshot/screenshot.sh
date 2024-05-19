#!/usr/bin/env bash

## Add to hyprland windowrule config
# ===========================

# 质量初始化
quality=$2

# 窗口截屏时留的边距
pos_lu=20 # lu: left up
pos_rd=40 # rd: right down

focused_window() {
    grim -l "$quality" -g "$(hyprctl activewindow -j |
        gojq -j '.at[0]-($gaps_lu | tonumber), ",", .at[1]-($gaps_lu | tonumber), " ", .size[0]+($gaps_rd | tonumber), "x", .size[1]+($gaps_rd | tonumber)' --arg gaps_lu $pos_lu --arg gaps_rd $pos_rd)" - |
        satty -f - --copy-command wl-copy --early-exit
}

take_fullscreen() {
    if $EDIT; then
        grim -l "$quality" -g "$(slurp -b "#ef5b9c30" -d)" - |
            satty -f - --copy-command wl-copy --early-exit
    else
        grim -l "$quality" -o "$(hyprctl monitors -j | gojq '.[] | select(.focused == true) | .name' -r)" - |
            wl-copy
    fi
}

# 截图后编辑
take_select_edit() {
    grim -l "$quality" -g "$(slurp -b "#ef5b9c30" -d)" - |
        satty -f - --copy-command wl-copy --early-exit
}

take_select() {
    grim -l "$quality" -g "$(slurp -b "#ef5b9c30" -d)" - |
        wl-copy
}

case $1 in
1) # 选区截图后发送剪切板
    take_select_edit
    ;;

2) # 当前显示器全屏截图后直接发送剪切板
    EDIT=true

    take_fullscreen
    ;;

3) # 活动窗口截图后直接发送剪切板
    focused_window
    ;;

4) # 当前显示器全屏截图后编辑
    #EDIT=true
    #pause_focused_screen &
    #take_fullscreen
    grim -l 1 -o $(hyprctl monitors -j | gojq '.[] | select(.focused == true) | .name' -r) - |
        satty -f - --fullscreen --init-tool crop --copy-command wl-copy --early-exit
    ;;
esac
