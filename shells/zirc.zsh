# zmodload zsh/zprof
# 自定义
source ~/.linuxConfig/shells/zshrc

typeset -A ZI
ZI[BIN_DIR]="${HOME}/.zi/bin"
source "${ZI[BIN_DIR]}/zi.zsh"

# last-working-dir thefuck 要用
ZSH_CACHE_DIR=~/.zi/cache

#############################################
# 自定义的 zsh lib directories
zi ice wait lucid; source ~/.linuxConfig/shells/lib/directories.zsh

#############################################

autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

zi ice wait lucid; zi light skywind3000/z.lua.git
eval "$(lua ~/.zi/plugins/skywind3000---z.lua.git/z.lua  --init zsh once enhanced)"
export _ZL_ECHO=1
export _ZL_DATA=~/.local/zlua

#############################################
# 补全
zi ice lucid wait as'completion'
zi light zsh-users/zsh-completions

zi ice as"completion"
zi snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

zi ice lucid wait as'completion' blockf has'tldr' mv'zsh_tealdeer -> _tldr'
zi snippet https://github.com/dbrgn/tealdeer/blob/main/completion/zsh_tealdeer

zi ice lucid wait as'completion' blockf has'mpv'
zi snippet https://github.com/mpv-player/mpv/blob/master/etc/_mpv.zsh

zi ice lucid wait as'completion' blockf has'fd'
zi snippet https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/fd/_fd

zi ice lucid wait as'completion' blockf has'rustc'
zi snippet https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/rust/_rustc

zi ice lucid wait as'completion' blockf has'cargo'
zi snippet https://github.com/rust-lang/cargo/blob/master/src/etc/_cargo

zi ice lucid wait as'completion' blockf has'pandoc'
zi light srijanshetty/zsh-pandoc-completion

zi ice wait lucid pick'autopair.zsh'
zi load hlissner/zsh-autopair

zi ice lucid wait has'fzf'
zi light Aloxaf/fzf-tab
zi ice wait lucid; zi light Freed-Wu/fzf-tab-source
source ~/.linuxConfig/shells/lib/fzf-tab.zsh

############################################################
# git
zi ice wait lucid; zi snippet OMZP::git

zi ice wait lucid; zi light paulirish/git-open.git

############################################################
# omz
# zi ice wait lucid; zi snippet OMZP::command-not-found
source /usr/share/doc/find-the-command/ftc.zsh

zi ice wait lucid; zi snippet OMZP::extract
zi ice wait lucid; zi snippet OMZP::thefuck

zi ice wait lucid; zi snippet OMZL::clipboard.zsh
zi ice wait lucid; zi snippet OMZL::functions.zsh
zi ice wait lucid; zi snippet OMZL::history.zsh

############################################################
# Misc

zi ice wait lucid; zi light lesonky/web-search.git

zi ice depth=1 lucid; zi light jeffreytse/zsh-vi-mode

zi ice wait lucid; zi light z-shell/H-S-MW

# 这两个插件按照这个顺序加载
zi ice wait lucid; zi light zsh-users/zsh-history-substring-search
zi ice wait lucid atinit"ZI[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zi light z-shell/F-Sy-H
# 高亮主题
# fast-theme ~/.linuxConfig/shells/z-shell.ini

# /bin/cat -v 然后按下按键查看,C-n,C-p 不知道为啥不成功
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

zi ice wait lucid atload"!_zsh_autosuggest_start"
zi load zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'

############################################################

# export PYTHONPATH=~/.local/lib/python3.11/site-packages

alias lazyvim="NVIM_APPNAME=lazyvim nvim"
alias nvchard="NVIM_APPNAME=NvChard nvim"

zi snippet OMZP::last-working-dir

eval "$(starship init zsh)"


export CLIPPY_CONF_DIR=~/.config/rustfmt/
# export PATH=~/.local/share/bob/nvim-bin:$PATH
# zprof
