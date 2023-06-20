#!/bin/bash

if [[ $(grep -c arch /etc/os-release) != 0 ]]; then
    if [[ ! $(command -v clash) ]]; then
    sudo pacman -S --needed --noconfirm clash
    fi
    if [[ ! $(command -v clash-meta) ]]; then
    sudo pacman -S --needed --noconfirm clash-meta
    fi
fi

if [[ -n $1 && --help =~ $1 ]]; then
    echo '第一个参数跟clash订阅链接，而且要给链接加上双引号'
    exit 0
fi

clash_dir="/etc/clash-meta"
clash_config=$clash_dir/config.yaml
clash_config=$HOME/config.yaml

if [[ ! -d $clash_dir ]]; then
    sudo mkdir $clash_dir
fi

# $1 写clash链接
if [[ -n $1 ]]; then
    sudo wget -O "$clash_config" "$1"
else
    echo '没有填写链接，不更新配置'
fi

# 设置端口等等
if [[ -f $clash_config ]]; then
    sudo sed -i 's/^mixed-port:.*/mixed-port: 7890/' "$clash_config"
    # sudo sed -i 's/enhanced-mode:.*/enhanced-mode: fake-ip/' $clash_config
    sudo sed -i 's/^mode:.*/mode: rule/' "$clash_config"
    sudo sed -i 's/^allow-lan:.*/allow-lan: true/' "$clash_config"
    sed -i '/^mode/a geox-url:\n  geoip: "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.dat"\n  geosite: "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geosite.dat"\n  mmdb: "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/country.mmdb"' "$clash_config"
fi

unset clash_dir clash_config

# sudo systemctl enable clash-meta
# sudo systemctl start clash-meta
