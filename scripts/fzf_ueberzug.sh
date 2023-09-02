#!/bin/bash

UB_PID_FILE="/tmp/.$(uuidgen)"
ueberzugpp layer --no-stdin --silent --use-escape-codes --pid-file "$UB_PID_FILE"
UB_PID=$(cat "$UB_PID_FILE")

export SOCKET=/tmp/ueberzugpp-$UB_PID.socket
export X=$(($(tput cols) / 2 + 1))

# run fzf with preview
# shellcheck disable=SC2016
fzf --preview='ueberzugpp cmd -s $SOCKET -i fzfpreview -a add -x $X -y 1 --max-width 40 --max-height 40 -f {}' --reverse "$@"

ueberzugpp cmd -s "$SOCKET" -a exit
