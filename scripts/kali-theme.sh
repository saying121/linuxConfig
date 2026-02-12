#!/usr/bin/env bash

set -ex

repo=/tmp/kali-themes
git clone --depth=1 https://gitlab.com/kalilinux/packages/kali-themes.git $repo
cd $repo || exit
cp -r $repo/share/themes ~/.themes
cp -r $repo/share/icons ~/.icons
cp -r $repo/share/color-schemes ~/.local/share/color-schemes

cp -r $repo/share/qt6ct/* ~/.config/qt6ct/
cp -r $repo/share/qt5ct/* ~/.config/qt5ct/

update_config() {
    local key=$1
    local value=$2
    local file=$3
    if grep -q "^$key=" "$file"; then
        # 存在则替换
        sed -i "s|^$key=.*|$key=\"$value\"|" "$file"
    else
        # 不存在则追加
        echo "$key=\"$value\"" >>"$file"
    fi
}

ICON="Flat-Remix-Blue-Dark"
THEME="Kali-Dark"

GTK_CONFS=("$HOME/.gtkrc-2.0" "$HOME/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini")
for file in "${GTK_CONFS[@]}"; do
    echo "update: $file"
    update_config "gtk-icon-theme-name" $ICON "$file"
    update_config "gtk-theme-name" $THEME "$file"
done

QT_CONFS=("$HOME/.config/qt5ct/qt5ct.conf" "$HOME/.config/qt6ct/qt6ct.conf")
for file in "${QT_CONFS[@]}"; do
    echo "update: $file"
    update_config "icon_theme" $ICON "$file"
    # update_config "color_scheme_path" $THEME "$file" # shit require a theme path
done
