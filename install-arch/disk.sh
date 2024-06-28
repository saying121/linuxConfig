#!/usr/bin/env bash

# 解析选项
TEMP=$(getopt -o b:e:s: --long btrfs:,efi:,swap: -- "$@")

# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
    echo "无效选项." >&2
    exit 1
fi

# 解析参数
eval set -- "$TEMP"

while true; do
    case "$1" in
    -b | --btrfs)
        btrfs_part="$2"
        shift 2
        echo "btrfs_part: -> $btrfs_part"
        ;;
    -e | --efi)
        efi_part="$2"
        shift 2
        echo "efi_part: -> $efi_part"
        ;;
    -s | --swap)
        swap_part="$2"
        shift 2
        echo "swap_part: -> $swap_part"
        ;;
    --)
        shift
        break
        ;;
    *)
        break
        ;;
    esac
done

# 检查三个选项是否都被提供
if [ -z "$btrfs_part" ] || [ -z "$efi_part" ] || [ -z "$swap_part" ]; then
    echo "错误: 必须提供 --btrfs, --efi 和 --swap 三个选项。" >&2
    exit 1
fi

# (1)efi
mkfs.vfat "$efi_part"

# (2)root and home
mkfs.btrfs "$btrfs_part"

# (3)swap
mkswap "$swap_part"
swapon "$swap_part"

# 3.
mount "$btrfs_part" /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@pkg
umount "$btrfs_part"

# ---

# root
mount "$btrfs_part" /mnt -o subvol=@,noatime,discard=async,compress=zstd

home=/mnt/home
mkdir $home
mount "$btrfs_part" $home -o subvol=@home,noatime,discard=async,compress=zstd

efi=/mnt/efi
mkdir $efi
mount for_efi $efi

log=/mnt/var/log
mkdir -p $log
mount "$btrfs_part" $log -o subvol=@log,noatime,discard=async,compress=zstd

pkg=/mnt/var/cache/pacman/pkg
mkdir -p $pkg
mount "$btrfs_part" $pkg -o subvol=@pkg,noatime,discard=async,compress=zstd

chattr +C /mnt/var/log
chattr +C /mnt/var/cache/pacman/pkg
