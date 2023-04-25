# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 自定义
source ~/.linuxConfig/shells/zshrc

typeset -A ZI
ZI[BIN_DIR]="${HOME}/.zi/bin"
source "${ZI[BIN_DIR]}/zi.zsh"

zi ice depth=1; zi light romkatv/powerlevel10k

autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

# 自定义的 zsh lib directories
zi ice wait lucid; source ~/.linuxConfig/shells/directories.zsh

# last-working-dir thefuck 要用
ZSH_CACHE_DIR=~/.zi/cache

export NVM_DIR="$HOME/.nvm"
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node

zi ice wait lucid; zi light skywind3000/z.lua.git
eval "$(lua ~/.zi/plugins/skywind3000---z.lua.git/z.lua  --init zsh once enhanced)"
export _ZL_ECHO=1

zi ice wait lucid; zi snippet OMZP::command-not-found
zi ice wait lucid; zi snippet OMZP::cp
zi ice wait lucid; zi snippet OMZP::vscode
zi ice wait lucid; zi snippet OMZP::extract
# zi ice wait lucid; zi snippet OMZ::plugins/history-substring-search/history-substring-search.zsh
# zi ice depth=1; zi snippet OMZP::history-substring-search
zi ice wait lucid; zi light zsh-users/zsh-history-substring-search

zi ice wait lucid; zi snippet OMZP::thefuck
zi ice wait lucid; zi snippet OMZP::nvm
zi ice wait lucid; zi snippet OMZP::pip
zi ice wait lucid; zi snippet OMZP::alias-finder

zi ice wait lucid; zi snippet OMZ::lib/clipboard.zsh
zi ice wait lucid; zi snippet OMZ::lib/functions.zsh
zi ice wait lucid; zi snippet OMZ::lib/history.zsh
zi ice wait lucid; zi snippet OMZ::lib/git.zsh

zi ice wait lucid; zi snippet OMZP::git
zi ice wait lucid; zi snippet OMZP::gitignore
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
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# export LESSOPEN='|~/.linuxConfig/shells/lessfilter.sh %s'
export LESSOPEN='|lesspipe.sh %s'


zi ice wait lucid; zi light z-shell/F-Sy-H
zi light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'

zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode

export PYTHONPATH=~/.local/lib/python3.10/site-packages

alias lazyvim="NVIM_APPNAME=LazyVim nvim"
alias nvchard="NVIM_APPNAME=NvChard nvim"
alias tvim="NVIM_APPNAME=NvimTest nvim"

zi snippet OMZP::last-working-dir

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# export PATH=~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin:$PATH
# export PATH=~/.rustup/toolchains/beta-x86_64-unknown-linux-gnu/bin:$PATH
