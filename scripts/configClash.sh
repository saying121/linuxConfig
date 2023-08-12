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

if [[ ! -d $clash_dir ]]; then
    sudo mkdir $clash_dir
fi

# sudo cp ~/.linuxConfig/configs/clash.yaml $clash_dir/config.yaml

sudo wget -O /etc/clash-meta/country.mmdb "https://ghproxy.com/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/country.mmdb"
sudo wget -O /etc/clash-meta/geosite.dat "https://ghproxy.com/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat"
sudo wget -O /etc/clash-meta/geoip.dat "https://ghproxy.com/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat"

# sudo sed -i.bak 's/url: ""/url: "'"$1"'"/' "$clash_config"

# 设置端口等等
if [[ -f $clash_config ]]; then
    sudo sed -i.bak 's/^mixed-port:.*/mixed-port: 7890/' "$clash_config"
    # sudo sed -i.bak 's/enhanced-mode:.*/enhanced-mode: fake-ip/' $clash_config
    sudo sed -i.bak 's/^mode:.*/mode: rule/' "$clash_config"
    sudo sed -i.bak 's/^allow-lan:.*/allow-lan: true/' "$clash_config"
    if [[ $(grep -c geox-url) = 0 ]]; then
        sudo sed -i.bak '/^external/a geox-url:\n  geoip: "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.dat"\n  geosite: "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geosite.dat"\n  mmdb: "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/country.mmdb"' "$clash_config"
    fi
    if [[ $(grep -c tun) = 0 ]]; then
        sudo sed -i.bak '/^external/a tun:\n  enable: true\n  device: Meta\n  stack: gvisor #system / gvisor / lwip\n  dns-hijack:\n    - 'any:53'\n  auto-route: true\n  auto-detect-interface: true' "$clash_config"
    fi
fi

# sudo setcap cap_net_bind_service,cap_net_admin=+ep /usr/bin/clash-meta

# sudo systemctl enable clash-meta
# sudo systemctl start clash-meta
