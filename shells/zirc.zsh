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
zi ice wait lucid; source ~/.linuxConfig/shells/lib/directories.zsh

# last-working-dir thefuck 要用
ZSH_CACHE_DIR=~/.zi/cache

zi ice wait lucid; zi light skywind3000/z.lua.git
eval "$(lua ~/.zi/plugins/skywind3000---z.lua.git/z.lua  --init zsh once enhanced)"
export _ZL_ECHO=1

zi ice lucid wait as'completion'
zi light zsh-users/zsh-completions

zi ice lucid wait as'completion' blockf has'rg'
zi snippet https://github.com/BurntSushi/ripgrep/blob/master/complete/_rg

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

zi ice wait lucid; zi snippet OMZP::command-not-found
zi ice wait lucid; zi snippet OMZP::cp
zi ice wait lucid; zi snippet OMZP::vscode
zi ice wait lucid; zi snippet OMZP::extract
zi ice wait lucid; zi snippet OMZP::nmap


zi ice wait lucid; zi snippet OMZP::thefuck
zi ice wait lucid; zi snippet OMZP::pip
zi ice wait lucid; zi snippet OMZP::alias-finder

zi ice wait lucid; zi snippet OMZL::clipboard.zsh
zi ice wait lucid; zi snippet OMZL::functions.zsh
zi ice wait lucid; zi snippet OMZL::history.zsh
zi ice wait lucid; zi snippet OMZL::git.zsh

zi ice wait lucid; zi snippet OMZP::git
zi ice wait lucid; zi snippet OMZP::gitignore
zi ice wait lucid; zi light paulirish/git-open.git

source ~/.zi/plugins/tj---git-extras/etc/git-extras-completion.zsh

zi ice wait lucid; zi light lesonky/web-search.git

zi ice as'null' sbin'bin/*'
zi light z-shell/zsh-diff-so-fancy

zi ice wait lucid; zi light z-shell/H-S-MW

zi ice wait lucid; zi light Aloxaf/fzf-tab
zi ice wait lucid; zi light Freed-Wu/fzf-tab-source
source ~/.linuxConfig/shells/lib/fzf-tab.zsh

zi ice wait lucid; zi light z-shell/F-Sy-H
# zi ice wait lucid; zi light zsh-users/zsh-history-substring-search
# zi ice wait lucid; zi snippet OMZL::key-bindings.zsh
# source ~/.linuxConfig/shells/lib/key-binding.zsh

# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down

zi light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'

zi ice depth=1 lucid; zi light jeffreytse/zsh-vi-mode

# export PYTHONPATH=~/.local/lib/python3.11/site-packages

alias lazyvim="NVIM_APPNAME=LazyVim nvim"
alias nvchard="NVIM_APPNAME=NvChard nvim"
alias tvim="NVIM_APPNAME=NvimTest nvim"
alias astronvim="NVIM_APPNAME=astronvim nvim"

zi snippet OMZP::last-working-dir

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi
# eval "$(starship init zsh)"

# alias nvimser="nvim --headless --listen localhost:7777"
# alias nvide="env -u WAYLAND_DISPLAY neovide --multigrid --server=localhost:7777"
