#!/bin/bash

# 先杀死进程
for wpid in $(pgrep linux-wallpaperengine); do
    kill -9 "$wpid"
done

wallpaper=~/.local/share/Steam/steamapps/workshop/content/431960

c=0
for file in "$wallpaper"/*; do
    my_array[c]=$file
    ((c++))
done

assets=~/.local/share/Steam/steamapps/common/wallpaper_engine/assets

cd ~/.local/share/wallpaperengine/share/ || exit
while :; do
    # 获取随机壁纸id
    the_rand=$((RANDOM % ${#my_array[@]}))
    if [[ -z $1 ]]; then
        id=${my_array[the_rand]}
    else
        id=$1
    fi

    # 在每个连接的显示器上输出
    for item in $(xrandr | awk '/\<connected\>/{print $1}'); do
        # nohup linux-wallpaperengine --silent --assets-dir $assets --screen-root $item $id & 2>&1 >/tmp/wallpaper.log
        linux-wallpaperengine --no-fullscreen-pause --silent --assets-dir $assets --screen-root "$item" "$id" & # >/dev/null &
    done

    sleep $((60 * 40))

    # killall 有时杀不死
    for wpid in $(pgrep linux-wallpaperengine); do
        kill -9 "$wpid"
    done
done
