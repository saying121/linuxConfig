#!/bin/bash

UB_PID_FILE="/tmp/.$(uuidgen)"
ueberzugpp layer --no-stdin --silent --use-escape-codes --pid-file "$UB_PID_FILE"
UB_PID=$(cat "$UB_PID_FILE")

export SOCKET=/tmp/ueberzugpp-$UB_PID.socket

export X=$(($(tput cols) / 2 + 1))

# ueberzugpp cmd -s "$SOCKET" -i fzfpreview -a add -x $X -y 1 --max-width "$FZF_PREVIEW_COLUMNS" --max-height "$FZF_PREVIEW_LINES" -f "$@"
ueberzugpp cmd -s "$SOCKET" -i fzfpreview -a add -x $X -y 1 --max-width 90 --max-height 90 -f "$@"
# sleep 3

# ueberzugpp cmd -s "$SOCKET" -a exit
