#!/usr/bin/env bash

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
    python <<EOF
import torch

data = torch.load("$1")
if isinstance(data, torch.Tensor):
    print(data.shape)
print(data)
EOF
elif [ "$kind" = json ]; then
    if [ "$(command -v jupyter)" ] && [ "$(command -v bat)" ] && [ "$ext" = ipynb ]; then
        jupyter nbconvert --to python --stdout "$1" | bat --color=always -plpython
    elif [ "$(command -v jq)" ]; then
        jq -Cr . "$1"
    fi
elif [ "$kind" = vnd.sqlite3 ]; then
    if [ "$(command -v yes)" ] && [ "$(command -v sqlite3)" ] && [ "$(command -v bat)" ]; then
        yes .q | sqlite3 "$1" | bat --color=always -plsql
    fi
    # https://github.com/wofr06/lesspipe/pull/107
elif [ -d "$1" ]; then
    if [ "$(command -v eza)" ]; then
        eza --git -hl --color=always --icons "$1"
    fi
    # https://github.com/wofr06/lesspipe/pull/110
elif [ "$kind" = pdf ]; then
    if [ "$(command -v pdftotext)" ] && [ "$(command -v sed)" ]; then
        pdftotext -q "$1" - | sed "s/\f/$(printf "%0.s-" {1..100})\n/g"
    fi
    # https://github.com/wofr06/lesspipe/pull/115
elif [ "$kind" = rfc822 ]; then
    if [ "$(command -v bat)" ]; then
        bat --color=always -lEmail "$1"
    fi
    # https://github.com/wofr06/lesspipe/pull/106
elif [ "$category" = image ]; then
    # --transfer-mode=memory is the fastest option but if you want fzf to be able
    # to redraw the image on terminal resize or on 'change-preview-window',
    # you need to use --transfer-mode=stream.
    if [[ $KITTY_WINDOW_ID ]]; then
        kitty icat --clear --transfer-mode=memory --stdin=no --place="$FZF_PREVIEW_COLUMNS"x"$FZF_PREVIEW_LINES"@0x0 "$1"
    elif [ "$(command -v chafa)" ]; then
        chafa -f symbols -s 70x60 "$1"
    fi
    if [ "$(command -v exiftool)" ]; then
        exiftool "$1" | bat --color=always -plyaml
    fi
    # https://github.com/wofr06/lesspipe/pull/117
elif [ "$category" = text ]; then
    if [ "$(command -v bat)" ]; then
        bat --color=always "$1"
    elif [ "$(command -v pygmentize)" ]; then
        pygmentize "$1" | less
    fi
else
    which "$1" 2>/dev/null
fi
