#!/bin/bash

wallpaper=~/.local/share/Steam/steamapps/workshop/content/431960

c=0
for file in $(ls $wallpaper); do
    my_array[$c]=$file
    ((c++))
done

assets=~/.local/share/Steam/steamapps/common/wallpaper_engine/assets

cd ~/.local/share/wallpaperengine/share/
while :; do
    the_rand=$(($RANDOM % ${#my_array[@]}))

    id=${my_array[$the_rand]}

    # nohup linux-wallpaperengine --silent --assets-dir $assets --screen-root $screen $id 2>&1 >/tmp/wallpaper.log
    # 在每个连接的显示器上输出
    for item in $(xrandr | awk '/\<connected\>/{print $1}'); do
        # nohup linux-wallpaperengine --silent --assets-dir $assets --screen-root $item $id & 2>&1 >/tmp/wallpaper.log
        linux-wallpaperengine --silent --assets-dir $assets --screen-root $item $id &
    done
    sleep $((60 * 40))
    # sleep 10
    killall linux-wallpaperengine
done
