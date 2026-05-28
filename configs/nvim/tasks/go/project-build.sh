#!/usr/bin/env bash

# "$HOME/.config/nvim/tasks/make_color.sh" go build "$VIM_FILEDIR"
"$HOME"/.config/nvim/tasks/make_color.sh go build -o "$VIM_FILEDIR"/build_go/"$VIM_FILENOEXT"
