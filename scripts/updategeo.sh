#!/usr/bin/env bash

mkdir -p /usr/local/share/dae/

geoip_file="/usr/local/share/dae/geoip.dat"
geoip_file_bak=$geoip_file".bak"
geosite_file="/usr/local/share/dae/geosite.dat"
geosite_file_bak=$geosite_file".bak"

[ -e $geoip_file ] && mv -f $geoip_file $geoip_file_bak
[ -e $geosite_file ] && mv -f $geosite_file $geosite_file_bak

if pgrep -x dae >/dev/null 2>&1; then
    curl -L -o $geoip_file https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
    curl -L -o $geosite_file https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
else
    curl -L -o $geoip_file https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat
    curl -L -o $geosite_file https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat
fi

if [[ ! -e "$geoip_file" || "$(stat -c%s $geoip_file)" -lt 11000000 && -s $geoip_file_bak ]]; then
    mv -f $geoip_file_bak $geoip_file
fi

if [[ ! -e "$geosite_file" || "$(stat -c%s $geosite_file)" -lt 6200000 && -s $geosite_file_bak ]]; then
    mv -f $geosite_file_bak $geosite_file
fi

# systemctl restart dae
