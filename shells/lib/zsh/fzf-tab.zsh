#!/usr/bin/env zsh

#zstyle ':completion:<function>:<completer>:<command>:<argument>:<tag>'

export RUNEWIDTH_EASTASIAN=0

# lesspipe.sh 会读取home的.lessfilter
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --history=$HOME/.zi/cache/fzfhistory --preview='~/.lessfilter {}' --bind 'alt-p:preview-up,alt-n:preview-down'"
export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,dist,vendor} --type f"

# export LESSOPEN='|lesspipe.sh %s'
export LESSOPEN='| ~/.lessfilter %s'

# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

zstyle ':fzf-tab:*' fzf-command fzf
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:complete:*:*' fzf-flags --height=60%
# zstyle ':fzf-tab:complete:*:*' fzf-preview 'which $word; echo $group'

bindkey '^Xh' _complete_help
# zstyle ':completion:alias-expension:*' completer _expand_alias

zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'

zstyle ':fzf-tab:user-expand:*' fzf-preview 'less ${(Q)word}'

zstyle ':fzf-tab:complete:(\\|)run-help:*' fzf-preview 'run-help $word'
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word'

zstyle ':fzf-tab:complete:cargo:*' fzf-preview 'cargo help $word | bat --color=always -plhelp'
zstyle ':fzf-tab:complete:cargo-(run|rustc|check):options' fzf-flags --preview-window=down:0:wrap
zstyle ':fzf-tab:complete:(rustup):*' fzf-flags --preview-window=down:3:wrap --height=50%

zstyle ':fzf-tab:complete:(pacman|paru|yay):options' fzf-flags --preview-window=down:0:wrap
zstyle ':fzf-tab:complete:(fnm):argument-1' fzf-flags --preview-window=down:0:wrap --height=50%

zstyle ':fzf-tab:complete:(lcode|perf|journalctl|jj|zi):*' fzf-flags --preview-window=down:3:wrap --height=50%

zstyle ':fzf-tab:complete:(pip-|pip--|pip3-|pip3--):argument-1' fzf-flags --preview-window=down:0:wrap --height=50%
zstyle ':fzf-tab:complete:(pip-install|pip3-install):argument-rest' fzf-flags --preview-window=down:0:wrap --height=50%

zstyle ':fzf-tab:complete:(python|python3):options' fzf-flags --preview-window=down:0:wrap --height=50%

zstyle ':fzf-tab:complete:uv:argument-1' fzf-flags --preview-window=down:6:wrap --height=50%
zstyle ':fzf-tab:complete:(uv|uv-pip-command-*|uv-command-*):options' fzf-flags --preview-window=down:0:wrap --height=50%
zstyle ':fzf-tab:complete:uv-command-*:argument-1' fzf-flags --preview-window=down:0:wrap --height=50%

# gcc in macos is gcc-14, g++-14 etc
zstyle ':fzf-tab:complete:(rg|gcc*|g++*|clang|clang++|psql|perf-*):options' fzf-flags --preview-window=down:3:wrap --height=50%
zstyle ':fzf-tab:complete:(rustc|sar|dd|strace|perf-*):*' fzf-flags --preview-window=down:3:wrap --height=50%

zstyle ':fzf-tab:complete:git-(diff|restore|add):*' --preview-window=down:3:wrap --height=50%
zstyle ':fzf-tab:complete:git-*:options' fzf-flags --preview-window=down:3:wrap --height=50%
zstyle ':fzf-tab:complete:git:argument-1' fzf-flags --preview-window=down:7:wrap --height=80%

zstyle ':fzf-tab:complete:_zlua:*' query-string input

# zstyle ':fzf-tab:*' group-colors $'\033[15m' $'\033[14m' $'\033[33m' $'\033[35m' $'\033[15m' $'\033[14m' $'\033[33m' $'\033[35m'
zstyle ':fzf-tab:*' prefix ''

zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ "$group" == *"process ID"* ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

zstyle ':fzf-tab:complete:(mise):argument-rest' fzf-flags --preview-window=down:0:wrap

# zstyle ':fzf-tab:complete:systemctl-status:*' command-arguments '(@)' '--user' fzf-preview 'systemctl --user status -- $word'
zstyle ':fzf-tab:complete:systemctl:argument-rest' fzf-flags --preview-window=down:5:wrap --height=60%

# Take advantage of $LS_COLORS for completion as well
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
