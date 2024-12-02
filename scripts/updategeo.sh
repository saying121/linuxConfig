#!/usr/bin/env bash

bold=$(tput bold)
yellow=$(tput setaf 3)
normal=$(tput sgr0)

dir=/usr/local/share/dae
mkdir -p $dir

geoip_file=$dir"/geoip.dat"
geosite_file=$dir"/geosite.dat"

down_geo() {
    target="$1"
    url="$2"

    tmp=$target".tmp"

    printf "${bold}%s${normal} %s ${bold}%s${normal}\n\n" "$tmp" "->" "$target"

    if wget -qO "$tmp" "$url"; then
        mv -f "$tmp" "$target"
    fi
}

if pgrep -x dae >/dev/null 2>&1; then
    prefix=https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download
else
    prefix=https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release
fi

printf "prefix: ${bold}${yellow}%s${normal}\n\n" $prefix

down_geo $geoip_file $prefix/geoip.dat &
down_geo $geosite_file $prefix/geosite.dat &

wait

# systemctl restart dae
