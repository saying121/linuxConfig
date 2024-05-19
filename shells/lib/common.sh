# vim:fileencoding=utf-8:ft=sh
# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    # shellcheck disable=2015
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip -c=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'  # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'  # begin bold
    export LESS_TERMCAP_me=$'\E[0m'     # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m' # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'     # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'  # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'     # reset underline
fi

# alias paru="paru --skipreivew"
alias kcat="kitty +kitten icat"
alias fimg=~/.linuxConfig/scripts/fzf_ueberzug.sh
alias yz="yazi"
yzcd() {
    tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi --cwd-file="$tmp"
    cwd="$(cat -- "$tmp")"
    if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd" || exit
    fi
    rm -f -- "$tmp"
}

function iplot {
    left=-15
    right=15

    while getopts "hl:r:" opt; do
        case $opt in
        l)
            left=$OPTARG
            ;;
        r)
            right=$OPTARG
            ;;
        h)
            echo "-l left bound
-r right bound"

            return 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2

            return 0
            ;;
        esac
    done

    shift $((OPTIND - 1))

    cat <<EOF | gnuplot
    # set xlabel "X Axis Label"
    set terminal pngcairo enhanced font 'Noto Sans Mono CJK SC,10'
    set autoscale
    set size ratio 1
    set samples 1000
    set output '|kitten icat --stdin yes'
    set object 1 rectangle from screen 0,0 to screen 1,1 fillcolor rgb"#fdf6e3" behind
    set xrange [ $left : $right]
    plot $@
    set output '/dev/null'
EOF
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
    alias lsd='eza -F -D --icons=always'
    alias ll='eza -F -lHhig --time-style long-iso --icons=always --git'
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

alias gpgme_err="sudo rm -R /var/lib/pacman/sync"

alias clhconf="~/.linuxConfig/scripts/configClash.sh"
alias clhres='sudo systemctl restart clash-meta@$USER.service'
alias clhstp='sudo systemctl stop clash-meta@$USER.service'
alias clhsts='systemctl status clash-meta@$USER.service'

alias rm="trash"
alias "sudo rm"="sudo trash"

alias tranen_zh='trans -j -d en:zh'
alias tranzh_en='trans -j -d zh:en'

alias upgrade='paru -Syu --noconfirm --overwrite "*" && paru -Fy && sudo pkgfile -u'
# alias upgrade='yay -Syu --noconfirm --overwrite "*" && yay -Fy && sudo pkgfile -u'
# alias upgrade='yay -Syu --noconfirm --overwrite "*" && yay -Fy'

cpv() {
    rsync -pogbr -hhh --backup-dir="/tmp/rsync-${USERNAME}" -e /dev/null --progress "$@"
}

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

thread_num=$(nproc)
export MAKEFLAGS="-j$thread_num"

export RUSTC_WRAPPER=sccache
export PATH=$PATH:~/.linuxConfig/scripts
