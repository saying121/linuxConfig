#!/usr/bin/env bash

sudo pacman -S --noconfirm --needed heaptrack valgrind tracy rizin
paru -S --noconfirm --needed hotspot
# perf report --addr2line ~/.cargo/bin/addr2line
cargo install --features="bin" addr2line
