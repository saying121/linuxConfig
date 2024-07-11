#!/usr/bin/env bash

sudo mkdir /etc/kanata
sudo cp ~/.linuxConfig/configs/kanata.kbd /etc/kanata/kanata.kbd
sudo install -m 644 ~/.linuxConfig/custom-services/kanata.service /lib/systemd/system/kanata.service
sudo systemctl daemon-reload
sudo systemctl enable --now kanata
