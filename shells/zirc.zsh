# zmodload zsh/zprof

eval "$(mise activate zsh)"

# 自定义
source ~/.linuxConfig/shells/zshrc
source ~/.linuxConfig/shells/lib/zsh/zsh-hook.zsh

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

# Misc
zi ice wait lucid; zi light paulirish/git-open.git

ZVM_VI_EDITOR=nvim
zi ice depth=1 lucid; zi light jeffreytse/zsh-vi-mode

# 这两个插件按照这个顺序加载
zi ice wait lucid atinit"ZI[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zi light z-shell/F-Sy-H
# 高亮主题
# fast-theme ~/.linuxConfig/shells/z-shell.ini

resume_job() {
    fg
}

zle -N resume_job
bindkey '^Z' resume_job


# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^Xe' edit-command-line
bindkey '^X^e' edit-command-line

############################################################

# export PYTHONPATH=~/.local/lib/python3.11/site-packages

alias lazyvim="NVIM_APPNAME=lazyvim nvim"
alias nvchard="NVIM_APPNAME=nvchard nvim"

eval "$(starship init zsh)"

# export CLIPPY_CONF_DIR=~/.config/rustfmt/
# export RUSTFLAGS="-Z threads=16"
# export PATH=~/.local/share/bob/nvim-bin:$PATH
export PATH=$PATH:~/.local/share/gem/ruby/3.0.0/bin
# export RUST_BACKTRACE=1
# export WASMTIME_DEBUG_BINDGEN=1

# zprof

# pnpm
export PNPM_HOME="/Users/saying/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
