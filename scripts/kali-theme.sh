#!/usr/bin/env bash

set -ex

git clone https://gitlab.com/kalilinux/packages/kali-themes.git
cd kali-theme || exit
cp -r share/themes ~/.themes

mv ~/.config/qt6ct ~/.config/qt6ct-bak
mv ~/.config/qt5ct ~/.config/qt5ct-bak

cp -r share/qt6ct ~/.config/qt6ct
cp -r share/qt5ct ~/.config/qt5ct
