#!/bin/bash

wallpaper=~/.linuxConfig/wallpaperengine/somePictures

c=0
for file in $(ls $wallpaper); do
    my_array[$c]=$file
    ((c++))
done

the_rand=$(($RANDOM % ${#my_array[@]}))

swaylock -i $wallpaper/${my_array[$the_rand]}
