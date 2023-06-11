# vim:fileencoding=utf-8:ft=sh
# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    # shellcheck disable=2015
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'  # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'  # begin bold
    export LESS_TERMCAP_me=$'\E[0m'     # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m' # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'     # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'  # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'     # reset underline
fi

# some more ls aliases
# alias ll='ls -l'
# alias la='ls -A'
# alias lal='ls -al'
# alias lla='ls -al'
# alias l='ls -CF'

cat() {
    if [[ $1 =~ \.md ]]; then
        mdcat "$@"
    else
        bat "$@"
    fi
}

# 确定发行版 kali㉿
declare -A releaseDic
releaseDic=(
    [arch]=" "
    [kali]=" "
    [ubuntu]=" "
    [suse]=" "
    [manjaro]=" "
    [pop]=" "
    [deepin]=" "
)
index=$(awk -F= '/^ID/{print $2}' </etc/os-release)
if [[ -n ${releaseDic[$index]} ]]; then
    prompt_symbol=${releaseDic[$index]}
else
    # shellcheck disable=2034
    prompt_symbol=" "
fi
unset releaseDic

# wsl
if [[ $(uname -a | grep -c WSL) != 0 ]]; then
    alias proxy="source ~/.linuxConfig/scripts/proxy.sh"
    # shellcheck disable=1090
    . ~/.linuxConfig/scripts/proxy.sh set
fi

# 自己的alias
alias ls='exa -F --icons'
alias ld='exa -FD --icons'
alias ll='exa -FlHhig --time-style long-iso --icons --git'
alias la='exa -F --all'
alias lal='ll -a'
alias lla='ll -a'
alias tree='exa -F -T --icons'
alias ltree='tree -l'

alias nvid='i3 move scratchpad && neovide'
alias show='i3 scratchpad show'

alias rewall='systemctl --user restart wallpaperengine.service'

alias icat="kitty +kitten icat"
# ImageMagick must be installed for icat to work.
alias imgcat="wezterm imgcat"
alias ueber="~/.linuxConfig/ueber.sh"

alias clhconf="~/.linuxConfig/scripts/configClash.sh"
alias clhres="sudo systemctl restart clash-meta.service"
alias clhstp="sudo systemctl stop clash-meta.service"
alias clhsts="systemctl status clash-meta.service"

# alias rm="gio trash"
alias rm="trash"
alias tl='trash-list'
alias rt='trash-restore'

alias tran='trans -j -d en:zh'

alias upgrade='yay -Syu --noconfirm && yay -Fy && sudo pkgfile -u'

if [[ $(grep -c OMZP::cp ~/.zshrc) != 0 && $SHELL == '/usr/bin/zsh' ]]; then
    alias cp='cpv -hhh'
fi

# avoid open nested ranger instances
ranger() {
    if [ -z "$RANGER_LEVEL" ]; then
        /usr/bin/ranger "$@"
    else
        exit
    fi
}
alias .r='source ranger'
alias r='ranger'

# lf
LFCD="$HOME/.config/lf/lfcd.sh"
source "$LFCD"

# export DISPLAY=:0

# config tldr
export TLDR_COLOR_NAME="cyan"
export TLDR_COLOR_DESCRIPTION="white"
export TLDR_COLOR_EXAMPLE="green"
export TLDR_COLOR_COMMAND="red"
export TLDR_COLOR_PARAMETER="white"
export TLDR_LANGUAGE="zh"
export TLDR_CACHE_ENABLED=1
export TLDR_CACHE_MAX_AGE=720
export TLDR_PAGES_SOURCE_LOCATION="https://raw.githubusercontent.com/tldr-pages/tldr/main/pages"
export TLDR_DOWNLOAD_CACHE_LOCATION="https://tldr-pages.github.io/assets/tldr.zip"

eval "$(fnm env --use-on-cd)"
# eval "$(jenv init -)"

source ~/.linuxConfig/shells/lib/nmap.sh
