#!/usr/bin/env bash

set -ex

repo=/tmp/kali-themes
git clone --depth=1 https://gitlab.com/kalilinux/packages/kali-themes.git $repo
cd $repo || exit
cp -r $repo/share/themes ~/.themes

mv ~/.config/qt6ct ~/.config/qt6ct-bak || echo "qt6 skip bak"
mv ~/.config/qt5ct ~/.config/qt5ct-bak || echo "qt5 skip bak"

cp -r $repo/share/qt6ct ~/.config/qt6ct
cp -r $repo/share/qt5ct ~/.config/qt5ct

update_config() {
    local key=$1
    local value=$2
    local file=$3
    if grep -q "^$key=" "$file"; then
        # 存在则替换
        sed -i "s|^$key=.*|$key=\"$value\"|" "$file"
    else
        # 不存在则追加
        echo "$key=\"$value\"" >> "$file"
    fi
}

FILE=~/.config/gtk-3.0/settings.ini
update_config "gtk-icon-theme-name" "Kali-Dark" "$FILE"
update_config "gtk-theme-name" "Kali-Dark" "$FILE"

FILE=~/.config/gtk-4.0/settings.ini
update_config "gtk-icon-theme-name" "Kali-Dark" "$FILE"
update_config "gtk-theme-name" "Kali-Dark" "$FILE"

FILE=~/.gtkrc-2.0
update_config "gtk-icon-theme-name" "Kali-Dark" "$FILE"
update_config "gtk-theme-name" "Kali-Dark" "$FILE"
