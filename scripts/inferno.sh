#!/bin/bash

# Linux
[[ -d flamegraph ]] || mkdir flamegraph

perf record --call-graph dwarf -o ./flamegraph/perf.data "$1"
cd flamegraph || exit
perf script | inferno-collapse-perf > stacks.folded
inferno-flamegraph < stacks.folded > flamegraph.svg
