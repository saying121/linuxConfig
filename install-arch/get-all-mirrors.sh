#!/bin/bash

if [[ -n $1 ]]; then
	curl -o "$1" https://archlinux.org/mirrorlist/all/
else
	curl -o all-mirrors.txt https://archlinux.org/mirrorlist/all/
fi
