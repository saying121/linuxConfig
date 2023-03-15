#!/bin/bash

# RTL881cu
sudo pacman -S --needed --noconfirm linux-headers dkms git bc iw nano sudo
# linux-docs usb_modeswitch
git clone https://github.com/morrownr/8821cu-20210118.git ~/Downloads/RTL8811CU
cd ~/Downloads/RTL8811CU || exit

# # Realtek 8211CU Wifi AC USB
# ATTR{idVendor}=="0bda", ATTR{idProduct}=="c811", RUN+="/usr/sbin/usb_modeswitch -K -v 0bda -p c811"

sudo ./install-driver.sh
