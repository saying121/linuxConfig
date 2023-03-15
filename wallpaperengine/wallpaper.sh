#!/bin/bash

wallpaper=~/.local/share/Steam/steamapps/workshop/content/431960

c=0

for file in $(ls $wallpaper)
do
    my_array[$c]=$file
    ((c++))
done

screen=$(xrandr | awk -F connected '/\<connected\>/{print $1}')

assets=~/.local/share/Steam/steamapps/common/wallpaper_engine/assets

cd ~/.local/share/wallpaperengine/share/


while :; do
    the_rand=$(($RANDOM % ${#my_array[@]}))

    id=${my_array[$the_rand]}

    # nohup linux-wallpaperengine --silent --assets-dir $assets --screen-root $screen $id 2>&1 >/tmp/wallpaper.log
    nohup linux-wallpaperengine --silent --assets-dir $assets --screen-root eDP-1 $id 2>&1 >/tmp/wallpaper.log
    sleep $((60 * 40))
    killall linux-wallpaperengine
done
