#!/usr/bin/env bash

[[ -d ~/.config/systemd/user ]] || mkdir -p ~/.config/systemd/user

cp ~/.linuxConfig/custom-services/kanshi.service ~/.config/systemd/user/

systemctl --user daemon-reload
systemctl --user enable --now kanshi.service
