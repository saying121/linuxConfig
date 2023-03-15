#!/bin/bash

echo '1.Partitioned disk
cfdisk /dev/xxx

2.Formatted disk
(1)efi
mkfs.vfat /dev/xxx

(2)root and home
mkfs.btrfs /dev/xxx

(3)swap
mkswap /dev/for_swap
swapon /dev/for_swap

3.Mount disk
(1)root
mount /dev/for_root /mnt

(2)efi
mkdir /mnt/boot
mount /dev/for_efi /mnt/boot

(3)home
mkdir /mnt/home
mount /dev/forhome /mnt/home

Change mirrors and link network before run the script.
yes/no'

read -r answer
if [[ ! $answer = yes ]]; then
	exit 0
fi

timedatectl set-ntp true
# 基础
pacstrap /mnt base base-devel linux linux-firmware zsh

genfstab -U /mnt >/mnt/etc/fstab
echo '----------------------------------------------------------
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
run: [cat /mnt/etc/fstab] compare to [lsblk],check for correctness
run: arch-chroot /mnt'
