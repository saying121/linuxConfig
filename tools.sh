#!/usr/bin/env bash

sudo pacman -S --noconfirm heaptrack valgrind tracy rizin
paru -S --noconfirm hotspot
# perf report --addr2line ~/.cargo/bin/addr2line
cargo binstall -y addr2line
