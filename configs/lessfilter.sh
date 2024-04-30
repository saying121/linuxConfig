#! /usr/bin/env bash
has_cmd() {
	for opt in "$@"; do
		command -v "$opt" >/dev/null
	done
}

mime=$(file -Lbs --mime-type "$1")
category=${mime%%/*}
kind=${mime##*/}
ext=${1##*.}
if [ "$kind" = octet-stream ]; then
	if [[ $1 == *events.out.tfevents.* ]]; then
		python <<EOF
from contextlib import suppress
import sys
from time import gmtime, strftime

import pandas as pd
import plotext as plt
from tensorboard.backend.event_processing.event_file_loader import (
    EventFileLoader,
)

file = "$1"
df = pd.DataFrame(columns=["Step", "Value"])
df.index.name = "YYYY-mm-dd HH:MM:SS"

for event in EventFileLoader(file).Load():
    with suppress(IndexError):
        df.loc[strftime("%F %H:%M:%S", gmtime(event.wall_time))] = [  # type: ignore
            event.step,  # type: ignore
            event.summary.value[0].tensor.float_val[0],  # type: ignore
        ]
df.index = pd.to_datetime(df.index)  # type: ignore
df.Step = df.Step.astype(int)
plt.plot(df.Step, df.Value, marker="braille")
plt.title(event.summary.value[0].metadata.display_name)  # type: ignore
plt.clc()
plt.show()
df.to_csv(sys.stdout, "\t")
EOF
	elif [[ $(basename "$1") == data.mdb ]]; then
		python <<EOF
from os.path import dirname as dirn
import lmdb

with lmdb.open(dirn("$1")) as env, env.begin() as txn:
    for key, val in txn.cursor():
        print(key.decode())
EOF
	fi
elif [ "$kind" = zip ] && [ "$ext" = pth ]; then
    # atool --list "$1"
	python <<EOF
import torch

data = torch.load("$1")
if isinstance(data, torch.Tensor):
    print(data.shape)
print(data)
EOF
elif [ "$kind" = json ]; then
	if has_cmd jupyter bat && [ "$ext" = ipynb ]; then
		jupyter nbconvert --to python --stdout "$1" | bat --color=always -plpython
	elif has_cmd jq; then
		jq -Cr . "$1"
	fi
elif [ "$kind" = vnd.sqlite3 ]; then
	if has_cmd yes sqlite3 bat; then
		yes .q | sqlite3 "$1" | bat --color=always -plsql
	fi
# https://github.com/wofr06/lesspipe/pull/107
elif [ -d "$1" ]; then
	if has_cmd eza; then
		eza -hl --git --color=always --icons "$1"
	elif has_cmd exa; then
		exa -hl --color=always --icons "$1"
	fi
# https://github.com/wofr06/lesspipe/pull/110
elif [ "$kind" = pdf ]; then
	if has_cmd pdftotext sed; then
		pdftotext -q "$1" - | sed "s/\f/$(hr ─)\n/g"
	fi
# https://github.com/wofr06/lesspipe/pull/115
elif [ "$kind" = rfc822 ]; then
	if has_cmd bat; then
		bat --color=always -lEmail "$1"
	fi
elif [ "$kind" = javascript ]; then
	if has_cmd bat; then
		bat --color=always -ljs "$1"
	fi
# https://github.com/wofr06/lesspipe/pull/106
elif [ "$category" = image ]; then
    # dim="$FZF_PREVIEW_COLUMNS"x"$FZF_PREVIEW_LINES"

    # x,y
    dim=$(stty size </dev/tty | awk '{printf "%.0fx%.0f", $2/2, $1/1.5}')

    if [[ $dim = x ]]; then
        dim=$(stty size </dev/tty | awk '{printf "%.0fx%.0f", $2/2, $1/1.5}')
    elif ! [[ $KITTY_WINDOW_ID ]] && ((FZF_PREVIEW_TOP + FZF_PREVIEW_LINES == $(stty size </dev/tty | awk '{print $1}'))); then
        # Avoid scrolling issue when the Sixel image touches the bottom of the screen
        # * https://github.com/junegunn/fzf/issues/2544
        dim=${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))
    fi

    if [[ $KITTY_WINDOW_ID ]]; then
        # 1. 'memory' is the fastest option but if you want the image to be scrollable,
        #    you have to use 'stream'.
        #
        # 2. The last line of the output is the ANSI reset code without newline.
        #    This confuses fzf and makes it render scroll offset indicator.
        #    So we remove the last line and append the reset code to its previous line.
        kitty icat --clear --transfer-mode=memory --unicode-placeholder --stdin=no --place="$dim"@0x0 "$1" | sed '$d' | sed $'$s/$/\e[m/'
    elif has_cmd chafa; then
        chafa -f sixel -s "$dim" "$1"
    elif has_cmd exiftool; then
        exiftool "$1" | bat --color=always -plyaml
    fi
# https://github.com/wofr06/lesspipe/pull/117
elif [ "$category" = text ]; then
	if has_cmd bat; then
		bat --color=always "$1"
	elif has_cmd pygmentize; then
		pygmentize "$1" | less
	fi
else
	exit 1
fi
