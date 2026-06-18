#!/usr/bin/env bash

echo "-1" | sudo tee /proc/sys/kernel/perf_event_paranoid
# echo "kernel.perf_event_paranoid = -1" | sudo tee /etc/sysctl.d/99-perf.conf && sudo sysctl --system
perf config --user annotate.addr2line=~/.cargo/bin/addr2line
