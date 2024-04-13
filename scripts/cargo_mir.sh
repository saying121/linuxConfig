#!/usr/bin/env bash

RUSTFLAGS="-Z dump-mir=$1 --emit=mir" cargo +nightly build --release
