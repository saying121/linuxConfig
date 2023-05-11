#!/bin/bash

if [[ $(grep -c arch /etc/os-release) != 0 && ! $(type clash) =~ clash ]]; then
    sudo pacman -S --needed --noconfirm clash clash-meta
fi

if [[ -n $1 && --help =~ $1 ]]; then
    echo '第一个参数跟clash订阅链接'
fi

clash_dir="/etc/clash-meta"
clash_config=$clash_dir/config.yaml

if [[ ! -d $clash_dir ]]; then
    sudo mkdir $clash_dir
fi

# $1 写clash链接
if [[ -n $1 ]]; then
    sudo wget -O $clash_config $1
else
    echo '没有填写链接，不更新配置'
fi

# 设置端口等等
if [[ -f $clash_config ]]; then
    sudo sed -i 's/^mixed-port:.*/mixed-port: 7890/' $clash_config
    # sudo sed -i 's/enhanced-mode:.*/enhanced-mode: fake-ip/' $clash_config
    sudo sed -i 's/^mode:.*/mode: rule/' $clash_config
    sudo sed -i 's/^allow-lan:.*/allow-lan: true/' $clash_config
fi

unset clash_dir clash_config

sudo systemctl enable clash-meta
sudo systemctl start clash-meta
