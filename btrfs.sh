#!/usr/bin/env bash

yay -S grub-btrfs snapper snapper-support

sudo systemctl enable --now snapper-cleanup.timer
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now grub-btrfsd.service

# /etc/systemd/system/grub-btrfsd.service
# sed -i
# ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto
