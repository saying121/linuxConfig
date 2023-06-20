#!/bin/bash

[[ -d ~/Downloads ]] || mkdir ~/Downloads
wget https://mirror.cachyos.org/cachyos-repo.tar.xz -O ~/Downloads/cachyos-repo.tar.xz
tar xvf ~/Downloads/cachyos-repo.tar.xz -C ~/Downloads

cd ~/Downloads/cachyos-repo || exit

sudo ./cachyos-repo.sh
