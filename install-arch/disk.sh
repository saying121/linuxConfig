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
mkfs.vfat /dev/"$efi_part"

# (2)root and home
mkfs.btrfs /dev/"$btrfs_part"

# (3)swap
mkswap /dev/"$swap_part"
swapon /dev/"$swap_part"

# 3.
mount /dev/"$btrfs_part" /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@pkg
umount /dev/"$btrfs_part"

# ---

# root
mount /dev/"$btrfs_part" /mnt -o subvol=@,noatime,discard=async,compress=zstd

mkdir /mnt/home
mount /dev/"$btrfs_part" /mnt/home -o subvol=@home,noatime,discard=async,compress=zstd

# (3)efi
mkdir /mnt/efi
mount /dev/for_efi /mnt/efi

mkdir -p /mnt/var/log
mount /dev/"$btrfs_part" /mnt/var/log -o subvol=@log,noatime,discard=async,compress=zstd

mkdir -p /mnt/var/cache/pacman/pkg
mount /dev/"$btrfs_part" /mnt/var/cache/pacman/pkg -o subvol=@pkg,noatime,discard=async,compress=zstd

chattr +C /mnt/var/log
chattr +C /mnt/var/cache/pacman/pkg
