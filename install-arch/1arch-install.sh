#!/bin/bash

printf '\e[1;33m
1.Partitioned disk
cfdisk /dev/xxx

2.Formatted disk
(1)efi
mkfs.vfat /dev/for_efi

(2)root and home
mkfs.btrfs /dev/my_btrfs

(3)swap
mkswap /dev/for_swap
swapon /dev/for_swap

3.
mount /dev/my_btrfs /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@pkg
umount /dev/my_btrfs

---

(1)root
mount /dev/my_btrfs /mnt -o subvol=@,noatime,discard=async,compress=zstd

(2)home
mkdir /mnt/home
mount /dev/my_btrfs /mnt/home -o subvol=@home,noatime,discard=async,compress=zstd

mkdir -p /mnt/var/log
mount /dev/my_btrfs /mnt/var/log -o subvol=@log,noatime,discard=async,compress=zstd

mkdir -p /mnt/var/cache/pacman/pkg
mount /dev/my_btrfs /mnt/var/cache/pacman/pkg -o subvol=@pkg,noatime,discard=async,compress=zstd

chattr +C /mnt/var/log
chattr +C /mnt/var/cache/pacman/pkg

(3)efi
mkdir /mnt/efi
mount /dev/for_efi /mnt/efi

4.End when chroot
edit /etc/mkinitcpio.conf
MODULES=() -> MODULES=(btrfs)

mkinitcpio -P

Change mirrors and link network before run the script.
yes/no
\e[0m
'

read -r answer
if [[ ! $answer = yes ]]; then
    exit 0
fi

timedatectl set-ntp true
# 基础
pacstrap /mnt base base-devel linux-cachyos linux-cachyos-headers linux-firmware zsh linux-firmware-qlogic

genfstab -U /mnt >/mnt/etc/fstab

printf '\e[1;33m
----------------------------------------------------------
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
run: [cat /mnt/etc/fstab] compare to [lsblk],check for correctness
run: arch-chroot /mnt
\e[0m
'
