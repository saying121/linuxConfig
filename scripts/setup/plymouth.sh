#!/usr/bin/env bash

paru -S plymouth-theme-connect-git

# /etc/mkinitcpio.conf
# HOOKS = (... plymouth)
#
# /etc/default/grub
# GRUB_CMDLINE_LINUX_DEFAULT="... splash"

sudo plymouth-set-default-theme -R connect
