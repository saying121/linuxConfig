#!/usr/bin/env bash

echo "-1" | sudo tee /proc/sys/kernel/perf_event_paranoid
perf config --user annotate.addr2line=~/.cargo/bin/addr2line
