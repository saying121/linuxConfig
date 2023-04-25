#!/bin/bash

# 先杀死进程
kill -9 $(ps -ef | grep linux-wallpaperengin[e] | awk '{print $2}')
# kill -9 $(ps -ef | grep .linuxConfig/wallpaperengine/wallpaper.s[h] | awk '{print $2}')

wallpaper=~/.local/share/Steam/steamapps/workshop/content/431960

c=0
for file in $(ls $wallpaper); do
    my_array[$c]=$file
    ((c++))
done

assets=~/.local/share/Steam/steamapps/common/wallpaper_engine/assets

cd ~/.local/share/wallpaperengine/share/
while :; do
    # 获取随机壁纸id
    the_rand=$(($RANDOM % ${#my_array[@]}))
    id=${my_array[$the_rand]}

    # 在每个连接的显示器上输出
    for item in $(xrandr | awk '/\<connected\>/{print $1}'); do
        # nohup linux-wallpaperengine --silent --assets-dir $assets --screen-root $item $id & 2>&1 >/tmp/wallpaper.log
        linux-wallpaperengine --no-fullscreen-pause --silent --assets-dir $assets --screen-root $item $id &
    done
    sleep $((60 * 40))
    # killall 有时杀不死
    kill -9 $(ps -ef | grep linux-wallpaperengin[e] | awk '{print $2}')
done
