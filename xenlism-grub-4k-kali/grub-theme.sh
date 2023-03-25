#!/bin/bash

sudo pacman -S --needed --noconfirm grub-customizer hwinfo

cd ~/.linuxConfig/xenlism-grub-4k-kali && su - root -c $(pwd)"/install.sh"
