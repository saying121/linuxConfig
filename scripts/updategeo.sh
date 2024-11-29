#!/usr/bin/env bash

dir=/usr/local/share/dae
mkdir -p $dir

geoip_file=$dir"/geoip.dat"
geosite_file=$dir"/geosite.dat"

down_geo() {
    target="$1"
    url="$2"

    tmp=$target".tmp"

    echo "-> $tmp -> $target"

    wget -qO "$tmp" "$url"

    if [[ $? ]]; then
        mv -f "$tmp" "$target"
    fi
}

if pgrep -x dae >/dev/null 2>&1; then
    echo "with dae"

    prefix=https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download

    down_geo $geoip_file $prefix/geoip.dat &
    down_geo $geosite_file $prefix/geosite.dat &
else
    echo "no dae"

    prefix=https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release

    down_geo $geoip_file $prefix/geoip.dat &
    down_geo $geosite_file $prefix/geosite.dat &
fi

wait

# systemctl restart dae
