#!/bin/bash

sh -c "$(curl -fsSL get.zshell.dev)" --

pacMan="pacman -S --needed --noconfirm"
sudo "$pacMan" pkgfile python3 \
    subversion lesspipe fastjar unrtf lesspipe catdoc id3v2 thefuck
sudo "$pacMan" rpmextract fastjar unzip unrar p7zip cabextract \
    cdrtools html2text ghostscript djvulibre odt2txt antiword catdoc \
    pandoc libreoffice-fresh unrtf mediainfo imagemagick unset pacMan
sudo pkgfile -u
pkgfile makepkg

[[ -d ~/.zi/cache ]] || mkdir ~/.zi/cache

curl https://raw.githubusercontent.com/LuRsT/hr/master/hr > ~/.local/bin/hr
chmod +x ~/.local/bin/hr
