#!/usr/bin/env bash

# proxy=https://mirror.ghproxy.com/

if [[ -n $1 ]]; then
    sudo mkdir -p /etc/dae/
    # sudo cp ~/.linuxConfig/configs/config.dae /etc/dae/config.dae
fi

sudo install -m 644 ~/.linuxConfig/custom-services/updategeo.service /lib/systemd/system/updategeo.service
sudo install -m 644 ~/.linuxConfig/custom-services/updategeo.timer /lib/systemd/system/updategeo.timer
sudo systemctl daemon-reload
sudo systemctl enable --now updategeo.timer
