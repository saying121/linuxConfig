export RUNEWIDTH_EASTASIAN=0

# lesspipe.sh 会读取home的.lessfilter
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --history=$HOME/.zi/cache/fzfhistory --preview='lesspipe.sh {}'"
export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,dist,vendor} --type f"

export LESSOPEN='|lesspipe.sh %s'

zstyle ':fzf-tab:*' fzf-command fzf
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:complete:*:*' fzf-flags --height=50%

zstyle ':fzf-tab:complete:pacman:*' fzf-preview "pacman -Qi $word | bat --color=always -plyaml || pacman -Si $word | bat --color=always -plyaml"
zstyle ':fzf-tab:complete:yay:*' fzf-preview "yay -Qi $word | bat --color=always -plyaml || yay -Si $word | bat --color=always -plyaml"
zstyle ':fzf-tab:complete:paru:*' fzf-preview "paru -Qi $word | bat --color=always -plyaml || yay -Si $word | bat --color=always -plyaml"

zstyle ':fzf-tab:complete:cargo:*' fzf-preview "cargo help $word | bat --color=always -plhelp"
zstyle ':fzf-tab:complete:rustc:*' fzf-preview "rustc help $word | bat --color=always -plhelp"

# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

zstyle ':fzf-tab:complete:_zlua:*' query-string input

zstyle ':fzf-tab:*' group-colors $'\033[15m' $'\033[14m' $'\033[33m' $'\033[35m' $'\033[15m' $'\033[14m' $'\033[33m' $'\033[35m'
zstyle ':fzf-tab:*' prefix ''

zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[ "$group" = "process ID" ] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

# Take advantage of $LS_COLORS for completion as well
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
