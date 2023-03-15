#!/bin/bash

which powerpill >/dev/null
if [[ $? == 0 ]]; then
	sudo powerpill -S --needed --noconfirm grub-customizer hwinfo
else
	sudo pacman -S --needed --noconfirm grub-customizer hwinfo
fi

cd ~/.linuxConfig/xenlism-grub-4k-kali && su - root -c $(pwd)"/install.sh"
