#zstyle ':completion:<function>:<completer>:<command>:<argument>:<tag>'

export RUNEWIDTH_EASTASIAN=0

# lesspipe.sh 会读取home的.lessfilter
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --history=$HOME/.zi/cache/fzfhistory --preview='lesspipe.sh {}'"
export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,dist,vendor} --type f"

export LESSOPEN='|lesspipe.sh %s'

# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

zstyle ':fzf-tab:*' fzf-command fzf
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:complete:*:*' fzf-flags --height=70%
# zstyle ':fzf-tab:complete:*:*' fzf-preview 'which $word; echo $group'

# bindkey '^a' alias-expension
bindkey '^Xh' _complete_help
# zstyle ':completion:alias-expension:*' completer _expand_alias

zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'

zstyle ':fzf-tab:complete:git-(diff|restore):*' fzf-preview 'git diff $word | delta'

zstyle ':fzf-tab:user-expand:*' fzf-preview 'less ${(Q)word}'

zstyle ':fzf-tab:complete:(\\|)run-help:*' fzf-preview 'run-help $word'
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word'

zstyle ':fzf-tab:complete:pacman:*' fzf-preview 'bat --color=always -plyaml <(pacman -Qi $word 2>/dev/null || pacman -Si $word)'
zstyle ':fzf-tab:complete:yay:*' fzf-preview 'bat --color=always -plyaml <(yay -Qi $word 2>/dev/null || yay -Si $word)'
zstyle ':fzf-tab:complete:paru:*' fzf-preview 'bat --color=always -plyaml <(paru -Qi $word 2>/dev/null || paru -Si $word)'

zstyle ':fzf-tab:complete:cargo:*' fzf-preview 'cargo help $word | bat --color=always -plhelp'
zstyle ':fzf-tab:complete:cargo-(run|rustc):options' fzf-flags --preview-window=down:0:wrap
zstyle ':fzf-tab:complete:(rustc|rg):*' fzf-preview 'echo $desc | bat --color=always -plhelp'
zstyle ':fzf-tab:complete:(rustc|rg):options' fzf-flags --preview-window=down:3:wrap
# zstyle ':fzf-tab:complete:(rustc|rg):directories' fzf-flags --height=70%

zstyle ':fzf-tab:complete:_zlua:*' query-string input

# zstyle ':fzf-tab:*' group-colors $'\033[15m' $'\033[14m' $'\033[33m' $'\033[35m' $'\033[15m' $'\033[14m' $'\033[33m' $'\033[35m'
zstyle ':fzf-tab:*' prefix ''

zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ "$group" == *"process ID"* ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

zstyle ':fzf-tab:complete:systemctl:argument-rest' fzf-flags --preview-window=down:3:wrap

# Take advantage of $LS_COLORS for completion as well
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
