#!/usr/bin/env bash

rank_main_mirror() {
    list=$(curl -s "https://archlinux.org/mirrorlist/?country=CN&protocol=https&use_mirror_status=on" |
        sed -e 's/^#Server/Server/' -e '/^#/d' |
        rankmirrors -n all -)
    echo "$list" | sudo tee /etc/pacman.d/mirrorlist
}

rank_mirror() {
    list=$(rankmirrors -n all - <"$1")

    echo "$list" | sudo tee /etc/pacman.d/"$2"
}

rank_mirror ./mirror_lists/archlinuxcn cnlist
rank_mirror ./mirror_lists/blackarch blackarch-mirrorlist
rank_main_mirror
