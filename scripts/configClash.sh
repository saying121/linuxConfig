#!/bin/bash
# shellcheck disable=2086

if [[ $(grep -c arch /etc/os-release) != 0 && ! $(type clash) =~ clash ]]; then
    sudo pacman -S --needed --noconfirm clash
fi
if [[ -n $1 && --help =~ $1 ]]; then
    echo '第一个参数跟clash订阅链接'
    #    exit 0
fi
clash_dir="/etc/clash"
clash_config=/etc/clash/config.yaml

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
    sudo sed -i 's/enhanced-mode:.*/enhanced-mode: fake-ip/' $clash_config
    sudo sed -i 's/^mode:.*/mode: rule/' $clash_config
    sudo sed -i 's/^allow-lan:.*/allow-lan: true/' $clash_config
fi

unset clash_dir clash_config

if [[ ! -f /etc/systemd/system/clash.service ]]; then
    sudo cp ~/.linuxConfig/custom-services/clash.service /etc/systemd/system/clash.service
fi

# clash路径
sudo sed -i "s#ExecStart=.* -f#ExecStart=$(which clash) -f#" /etc/systemd/system/clash.service

sudo systemctl daemon-reload
sudo systemctl enable clash
sudo systemctl start clash
