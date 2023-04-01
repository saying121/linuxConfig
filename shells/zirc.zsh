source ~/.linuxConfig/shells/zshrc

typeset -A ZI
ZI[BIN_DIR]="${HOME}/.zi/bin"
source "${ZI[BIN_DIR]}/zi.zsh"

ZSH_CACHE_DIR=~/.zi/cache

export NVM_DIR="$HOME/.nvm"
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node

zi snippet OMZP::last-working-dir

zi ice wait lucid; zi light skywind3000/z.lua.git
eval "$(lua ~/.zi/plugins/skywind3000---z.lua.git/z.lua  --init zsh once enhanced)"
export _ZL_ECHO=1

zi ice wait lucid; zi snippet OMZP::command-not-found
zi ice wait lucid; zi snippet OMZP::cp
zi ice wait lucid; zi snippet OMZP::vscode
zi ice wait lucid; zi snippet OMZP::extract
zi ice wait lucid; zi snippet OMZ::plugins/history-substring-search/history-substring-search.zsh
zi ice wait lucid; zi snippet OMZ::plugins/thefuck/thefuck.plugin.zsh
zi ice wait lucid; zi snippet OMZP::nvm
zi ice wait lucid; zi snippet OMZP::pip
zi ice wait lucid; zi snippet OMZP::alias-finder

zi ice wait lucid; zi snippet OMZ::lib/clipboard.zsh
zi ice wait lucid; zi snippet OMZ::lib/functions.zsh
# zi ice wait lucid; zi snippet OMZ::lib/completion.zsh
zi ice wait lucid; zi snippet OMZ::lib/history.zsh
zi ice wait lucid; zi snippet OMZ::lib/key-bindings.zsh
zi ice wait lucid; zi snippet OMZ::lib/git.zsh
zi ice wait lucid; zi snippet OMZ::lib/directories.zsh

zi ice wait lucid; zi snippet OMZP::git
zi ice wait lucid; zi snippet OMZP::gitignore

zi ice wait lucid; zi light z-shell/z-a-rust
zi ice wait lucid; zi light paulirish/git-open.git
zi ice wait lucid; zi light lesonky/web-search.git

zi ice wait lucid; zi light Aloxaf/fzf-tab
zi ice wait lucid; zi light Freed-Wu/fzf-tab-source
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# export LESSOPEN='|~/.linuxConfig/shells/lessfilter.sh %s'
export LESSOPEN='|lesspipe.sh %s'

zi ice wait lucid; zi light z-shell/F-Sy-H
zi light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'

# zi light zsh-users/zsh-syntax-highlighting
#
# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
# ZSH_HIGHLIGHT_STYLES[default]=none
# ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=white,underline
# ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
# ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
# ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
# ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
# ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
# ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
# ZSH_HIGHLIGHT_STYLES[path]=bold
# ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
# ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
# ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
# ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
# ZSH_HIGHLIGHT_STYLES[command-substitution]=none
# ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
# ZSH_HIGHLIGHT_STYLES[process-substitution]=none
# ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
# ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
# ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
# ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
# ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
# ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
# ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
# ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
# ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
# ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
# ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
# ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
# ZSH_HIGHLIGHT_STYLES[assign]=none
# ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
# ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
# ZSH_HIGHLIGHT_STYLES[named-fd]=none
# ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
# ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
# ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
# ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
# ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
# ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
# ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
# ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
# ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
