#!/bin/bash

DEFAULT_WALLPAPER_DIR="${HOME}/.linuxConfig/wallpaperengine/somePictures"
KALI_WALLPAPER_DIR="/usr/share/backgrounds/kali"

wallpaper=$KALI_WALLPAPER_DIR

if [ -d "${KALI_WALLPAPER_DIR}" ]; then
  wallpaper="${KALI_WALLPAPER_DIR}"
else
  wallpaper="${DEFAULT_WALLPAPER_DIR}"
fi


c=0
for file in "$wallpaper"/*.{png,jpe?g}; do
    my_array[c]=$file
    ((c++))
done

the_rand=$((RANDOM % ${#my_array[@]}))

swaylock -i "${my_array[the_rand]}"
