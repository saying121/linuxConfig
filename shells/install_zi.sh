#!/bin/bash

sh -c "$(curl -fsSL get.zshell.dev)" --

pacMan="sudo pacman -S --needed --noconfirm"
$pacMan pkgfile python3 \
    subversion lesspipe fastjar unrtf lesspipe catdoc id3v2 thefuck diff-so-fancy
$pacMan rpmextract fastjar unzip unrar p7zip cabextract \
    cdrtools html2text ghostscript djvulibre odt2txt antiword catdoc \
    pandoc libreoffice-fresh unrtf mediainfo imagemagick grc atuin
yay -S --needed --noconfirm find-the-command
# sudo pkgfile -u
pkgfile makepkg

[[ -d ~/.zi/cache ]] || mkdir ~/.zi/cache
