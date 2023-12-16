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

alias kcat="kitty +kitten icat"
alias fimg=~/.linuxConfig/scripts/fzf_ueberzug.sh
alias yz="yazi"
function yzcd() {
    tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi --cwd-file="$tmp"
    cwd="$(cat -- "$tmp")"
    if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd" || exit
    fi
    rm -f -- "$tmp"
}

cat() {
    mime=$(file -Lbs --mime-type "$1")
    category=${mime%%/*}
    if [[ $1 =~ .*.md ]]; then
        mdcat "$@"
    elif [[ "$category" = image ]]; then
        kcat "$@"
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
    # shellcheck disable=SC1090
    . ~/.linuxConfig/scripts/proxy.sh set
fi

if [[ $(command -v eza) ]]; then
    alias ls='eza -F --icons=always'
    alias ld='eza -FD --icons=always'
    alias ll='eza -FlHhig --time-style long-iso --icons=always --git'
    alias la='eza -F --all'
    alias lal='ll -a'
    alias lla='ll -a'
    alias tree='eza -F -T --icons=always'
    alias ltree='tree -l'
else
    alias ll='ls -l'
    alias la='ls -A'
    alias lal='ls -al'
    alias lla='ls -al'
    alias l='ls -CF'
fi

# alias nvid='i3 move scratchpad && neovide'
# alias show='i3 scratchpad show'

# alias rewall='systemctl --user restart wallpaperengine.service'
alias rewall="~/.linuxConfig/wallpaperengine/rewall.sh"

# ImageMagick must be installed for icat to work.
alias imgcat="wezterm imgcat"

alias my_gpgme="sudo rm -R /var/lib/pacman/sync"

alias clhconf="~/.linuxConfig/scripts/configClash.sh"
alias clhres="sudo systemctl restart clash-meta@$USER.service"
alias clhstp="sudo systemctl stop clash-meta@$USER.service"
alias clhsts="systemctl status clash-meta@$USER.service"

alias rm="trash"

alias tran='trans -j -d en:zh'

alias upgrade='yay -Syu --noconfirm --overwrite "*" && yay -Fy && sudo pkgfile -u'

if [[ $(grep -c OMZP::cp ~/.zshrc) != 0 && $SHELL == *'zsh' ]]; then
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
# shellcheck disable=SC1090
source "$LFCD"

eval "$(fnm env --use-on-cd)"
# eval "$(jenv init -)"

# shellcheck disable=SC1090
source ~/.linuxConfig/shells/lib/nmap.sh

# rust 开启测试覆盖率
cover_rust() {
    if [[ "$1" == "set" ]]; then
        export RUSTFLAGS="-Cinstrument-coverage"
        export LLVM_PROFILE_FILE="%p-%m.profraw"
    fi
    if [[ "$1" == "unset" ]]; then
        unset RUSTFLAGS
        unset LLVM_PROFILE_FILE
    fi
}

debug_rust() {
    if [[ "$1" == "set" ]]; then
        export RUST_LOG=DEBUG
    fi
    if [[ "$1" == "unset" ]]; then
        unset RUST_LOG
    fi
}

export MAKEFLAGS='-j'

export RUSTC_WRAPPER=sccache
export PATH=$PATH:~/.linuxConfig/scripts
