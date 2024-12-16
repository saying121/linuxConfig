#!/usr/bin/env bash

rustup install stable nightly
channel=(stable nightly)
for ch in "${channel[@]}"; do
    rustup component add rust-analyzer clippy rustfmt llvm-tools-preview --toolchain "$ch"
done
rustup component add miri --toolchain nightly
# rustup default nightly

# 切换 crates 源
# cargo binstall -y crm
# ~/.cargo/bin/crm use rsproxy
cargo binstall -y cargo-cache tokio-console sea-orm-cli cargo-export

# rust 交叉编译
# rustup target add x86_64-pc-windows-gnu aarch64-apple-darwin x86_64-apple-darwin
# rustup toolchain install stable-x86_64-pc-windows-gnu stable-aarch64-apple-darwin stable-x86_64-apple-darwin --force-non-host
# $aurPkg mingw-w64-gcc osxcross-git
