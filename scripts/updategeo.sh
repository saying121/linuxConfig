#!/usr/bin/env bash

dir=/usr/local/share/dae
mkdir -p $dir

geoip_file=$dir"/geoip.dat"
geosite_file=$dir"/geosite.dat"

down_geo() {
    target="$1"
    url="$2"

    tmp=$target".tmp"
    echo "$target"
    echo "$tmp"

    curl -L -o "$tmp" "$url"

    if [[ $? ]]; then
        mv -f "$tmp" "$target"
    fi
}

if pgrep -x dae >/dev/null 2>&1; then
    echo "with dae"
    down_geo $geoip_file https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
    down_geo $geosite_file https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
else
    echo "no dae"
    down_geo $geoip_file https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat
    down_geo $geosite_file https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat
fi

# systemctl restart dae
