#!/bin/bash

# systemctl --user restart wallpaperengine.service

killall wallpaper.sh >>/dev/null
nohup ~/.linuxConfig/wallpaperengine/wallpaper.sh >>/dev/null 2>&1 &
