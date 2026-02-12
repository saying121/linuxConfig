#!/usr/bin/env bash

DEFAULT_WALLPAPER_DIR="${HOME}/.linuxConfig/wallpaperengine/somePictures"
KALI_WALLPAPER_DIR="/usr/share/backgrounds/kali-16x9"

wallpaper=$KALI_WALLPAPER_DIR

if [ -d "${KALI_WALLPAPER_DIR}" ]; then
    wallpaper="${KALI_WALLPAPER_DIR}"
else
    wallpaper="${DEFAULT_WALLPAPER_DIR}"
fi

my_array=("$wallpaper"/*)

len=${#my_array[@]}

# 檢查陣列是否為空，防止 RANDOM 除以零
if [[ $len -eq 0 ]]; then
    echo "未找到任何背景！"
    exit 1
fi

# 隨機選取並執行
echo "${my_array[RANDOM % $len]}"
