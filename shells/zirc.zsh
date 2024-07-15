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

# 补全
source ~/.linuxConfig/shells/lib/zsh/completions.zsh

# omz
source ~/.linuxConfig/shells/lib/zsh/omz.zsh

# zi ice wait lucid service"redis"
# zi light z-shell/redis
#
# GIT_SLEEP_TIME=700
# GIT_PROJECTS=z-shell/zsh-github-issues:z-shell/zi
#
# zi ice wait lucid service"GIT" pick"zsh-github-issues.service.zsh"
# zi light z-shell/zsh-github-issues

# Misc
zi ice wait lucid; zi light paulirish/git-open.git

zi ice wait lucid; zi light lesonky/web-search.git

# eval "$(atuin init zsh)"

zi ice depth=1 lucid; zi light jeffreytse/zsh-vi-mode

zi ice wait lucid; zi light z-shell/H-S-MW

# 这两个插件按照这个顺序加载
zi ice wait lucid; zi light zsh-users/zsh-history-substring-search
zi ice wait lucid atinit"ZI[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zi light z-shell/F-Sy-H
# 高亮主题
# fast-theme ~/.linuxConfig/shells/z-shell.ini

# /bin/cat -v 然后按下按键查看按键对应字符串, C-n,C-p 不知道为啥不成功
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

resume_job() {
    fg
}

zle -N resume_job
bindkey '^Z' resume_job


# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

############################################################

# export PYTHONPATH=~/.local/lib/python3.11/site-packages

alias lazyvim="NVIM_APPNAME=lazyvim nvim"
alias nvchard="NVIM_APPNAME=nvchard nvim"

eval "$(starship init zsh)"


export CLIPPY_CONF_DIR=~/.config/rustfmt/
# export RUSTFLAGS="-Z threads=16"
# export PATH=~/.local/share/bob/nvim-bin:$PATH
export PATH=$PATH:~/.local/share/gem/ruby/3.0.0/bin
export RUST_BACKTRACE=1
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.local/lib/mojo
# export WASMTIME_DEBUG_BINDGEN=1

# zprof
