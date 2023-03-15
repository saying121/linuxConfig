#!/bin/sh
# shellcheck disable=2002,2086
hostip=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
# wslip=$(hostname -I | awk '{print $1}')
wslip=$(ip address show eth0|grep 'scope global'|awk '{print $2}'|awk -F/ '{print $1}')
port=7890

PROXY_HTTP="http://${hostip}:${port}"

set_proxy() {
    export http_proxy="${PROXY_HTTP}"
    export HTTP_PROXY="${PROXY_HTTP}"

    export https_proxy="${PROXY_HTTP}"
    export HTTPS_proxy="${PROXY_HTTP}"

    git config --global http.proxy "${PROXY_HTTP}"
    git config --global https.proxy "${PROXY_HTTP}"
}

unset_proxy() {
    unset http_proxy
    unset HTTP_PROXY
    unset https_proxy
    unset HTTPS_PROXY

    git config --global --unset http.proxy
    git config --global --unset https.proxy
}

test_setting() {
    echo "Host ip:" ${hostip}
    echo "WSL ip:" ${wslip}
    echo "Current proxy:" $https_proxy
}

if [ "$1" = "set" ]; then
    set_proxy

elif [ "$1" = "unset" ]; then
    unset_proxy

elif [ "$1" = "test" ]; then
    test_setting
else
    echo "Unsupported arguments."
fi
