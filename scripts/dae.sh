#!/usr/bin/env bash

proxy=https://mirror.ghproxy.com/

sudo mkdir -p /usr/local/share/dae/
pushd /usr/local/share/dae/ || exit

sudo curl -L -o geoip.dat "$proxy"https://github.com/v2fly/geoip/releases/latest/download/geoip.dat
sudo curl -L -o geosite.dat "$proxy"https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat

popd || exit
