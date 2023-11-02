#!/bin/bash

sh -c "$(curl -fsSL get.zshell.dev)" --

pacMan="sudo pacman -S --needed --noconfirm"
$pacMan pkgfile python3 \
    subversion lesspipe fastjar unrtf lesspipe catdoc id3v2 thefuck diff-so-fancy
$pacMan rpmextract fastjar unzip unrar p7zip cabextract \
    cdrtools html2text ghostscript djvulibre odt2txt antiword catdoc \
    pandoc libreoffice-fresh unrtf mediainfo imagemagick
# sudo pkgfile -u
pkgfile makepkg

[[ -d ~/.zi/cache ]] || mkdir ~/.zi/cache

# ln -s ~/.linuxConfig/shells/lib/lessfilter.sh ~/.lessfilter

curl https://raw.githubusercontent.com/LuRsT/hr/master/hr >~/.local/bin/hr
chmod +x ~/.local/bin/hr
