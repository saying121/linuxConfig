#!/bin/bash

yay -S timeshift grub-btrfs

sudo systemctl enable --now cronie.service
sudo systemctl enable --now grub-btrfsd.service
