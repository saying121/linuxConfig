#!/usr/bin/env bash

export RUSTFLAGS="-C llvm-args=--pass-remarks-missed=loop-vectorize -Cdebuginfo=2"
export RUSTFLAGS="-C llvm-args=--pass-remarks-missed=.* -Cdebuginfo=2"
