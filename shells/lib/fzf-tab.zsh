export RUNEWIDTH_EASTASIAN=0

export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --history=$HOME/.zi/cache/fzfhistory --preview=\"$HOME/.linuxConfig/shells/lib/lessfilter.sh {}\""
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --history=$HOME/.zi/cache/fzfhistory --preview='lesspipe.sh {}'"

export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,dist,vendor} --type f"

# disable sort when completing `git checkout`
# zstyle ':completion:*:git-checkout:*' sort false

zstyle ':fzf-tab:*' fzf-command fzf
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

zstyle ':completion:complete:*:options' sort false
zstyle ':fzf-tab:complete:_zlua:*' query-string input

# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format "[%d]"

zstyle ':fzf-tab:*' group-colors $'\033[15m' $'\033[14m' $'\033[33m' $'\033[35m' $'\033[15m' $'\033[14m' $'\033[33m' $'\033[35m'
zstyle ':fzf-tab:*' prefix ''
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[ "$group" = "process ID" ] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

zstyle ':fzf-tab:complete:pacman:*' fzf-preview "pacman -Qi $word | bat --color=always -plyaml || pacman -Si $word | bat --color=always -plyaml"
zstyle ':fzf-tab:complete:yay:*' fzf-preview "yay -Qi $word | bat --color=always -plyaml || yay -Si $word | bat --color=always -plyaml"
zstyle ':fzf-tab:complete:paru:*' fzf-preview "paru -Qi $word | bat --color=always -plyaml || yay -Si $word | bat --color=always -plyaml"

zstyle ':fzf-tab:complete:cargo:*' fzf-preview "cargo help $word | bat --color=always -plhelp"
zstyle ':fzf-tab:complete:rustc:*' fzf-preview "rustc help $word | bat --color=always -plhelp"

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

zstyle ':fzf-tab:complete:*:*' fzf-flags --height=50%

# export LESSOPEN="|$HOME/.linuxConfig/shells/lib/lessfilter.sh %s"
export LESSOPEN='|lesspipe.sh %s'
