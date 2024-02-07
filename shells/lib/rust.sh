#!/usr/bin/env bash

cargomir() {
    cargo rustc --bin="$1" -- -Z unpretty=mir
}

alias rustmir='rustc --edition 2021 -Z unpretty=mir'
