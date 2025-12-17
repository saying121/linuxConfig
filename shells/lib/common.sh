# vim:fileencoding=utf-8:ft=sh

export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH
export PATH=$PATH:~/.linuxConfig/scripts
export PATH=$PATH:~/.ghcup/bin

export PATH=$PATH:~/.cargo/bin:~/.local/bin:~/go/bin
export GOPATH=~/.local/share/go
export GOBIN=~/.local/share/go/bin
export PATH="$PATH:/opt/homebrew/opt/rustup/bin"
export PATH="$PATH:$GOBIN"
export HOMEBREW_NO_AUTO_UPDATE=1

# enable color support of ls, less and man, and also add handy aliases
the_dircolors=dircolors
# macos install `coreutils`
if command -v gdircolors &>/dev/null; then
    the_dircolors=gdircolors
fi

# shellcheck disable=2015
test -r ~/.dircolors && eval "$($the_dircolors -b ~/.dircolors)" || eval "$($the_dircolors -b)"

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
# declare -A releaseDic
# releaseDic=(
#     [arch]=" "
#     [kali]=" "
#     [ubuntu]=" "
#     [suse]=" "
#     [manjaro]=" "
#     [pop]=" "
#     [deepin]=" "
# )
# index=$(awk -F= '/^ID/{print $2}' </etc/os-release)
# if [[ -n ${releaseDic[$index]} ]]; then
#     prompt_symbol=${releaseDic[$index]}
# else
#     # shellcheck disable=2034
#     prompt_symbol=" "
# fi
# unset releaseDic

# wsl
if [[ $(uname -a | grep -c WSL) != 0 ]]; then
    alias proxy="source ~/.linuxConfig/scripts/proxy.sh"
    # shellcheck disable=SC1090
    . ~/.linuxConfig/scripts/proxy.sh set
fi

if command -v eza >/dev/null; then
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

if hash sudo-rs >/dev/null 2>&1; then
    sudo() {
        # 1. 初始化一个标志变量，用于记录是否找到了 -E 参数
        local has_e_flag=0

        # 2. 遍历所有传入的参数 ("$@" 能正确处理带空格的参数)
        for arg in "$@"; do
            # 3. 如果当前参数正好是 "-E"
            if [[ "$arg" == "-E" ]]; then
                has_e_flag=1
                break # 4. 找到后，设置标志并立即退出循环，无需再检查后续参数
            fi
        done

        # 5. 检查标志变量的值
        if ((has_e_flag == 1)); then
            # 如果标志为1 (表示找到了-E)，就调用原始的 sudo 命令
            # `command` 用来防止函数无限循环调用自身
            command sudo "$@"
        else
            # 否则，调用 sudo-rs
            sudo-rs "$@"
        fi

        # if ((${argv[(i) - E]} <= $#)); then
        #     # 如果找到了 '-E'，就使用 `command` 来调用原始的 sudo 命令，防止无限循环
        #     command sudo "$@"
        # else
        #     sudo-rs "$@"
        # fi
    }
fi

# alias nvid='i3 move scratchpad && neovide'
# alias show='i3 scratchpad show'

# alias rewall='systemctl --user restart wallpaperengine.service'
alias rewall="~/.linuxConfig/wallpaperengine/rewall.sh"

# ImageMagick must be installed for icat to work.
alias imgcat="wezterm imgcat"

alias gpgme_err="sudo rm -R /var/lib/pacman/sync"

alias rm="trash"

alias tranen_zh='trans -j -d en:zh'
alias tranzh_en='trans -j -d zh:en'

alias upgrade='paru -Syu --sudoloop --noconfirm --overwrite "*"; paru -Fy --sudoloop; sudo pkgfile -u'
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

if which fnm >/dev/null; then
    eval "$(fnm env --use-on-cd)"
fi
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

# thread_num=$(nproc)
export MAKEFLAGS="-j"

export EDITOR=nvim

alias gitlog="git log --graph --pretty=format:'%>|(12,trunc)%Cred%h%Creset  -  %C(yellow)%<(60,trunc)%s%Creset %Cgreen%<(30,trunc)%d %C(bold blue)%<(15,trunc)%an%Creset%>(1)%>(50)%cd' --date=format-local:'%Y-%m-%d %H:%M:%S'"

if [[ $TERM = "xterm-kitty" ]]; then
    alias ssh="kitten ssh"
fi
alias daeres="sudo systemctl restart dae"
alias daestop="sudo systemctl stop dae"

export SCCACHE_CACHE_SIZE="40G"
export RUSTC_WRAPPER=sccache

if command -v brew >/dev/null 2>&1; then
    DYLD_FALLBACK_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_FALLBACK_LIBRARY_PATH"
    export DYLD_FALLBACK_LIBRARY_PATH
fi

# export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
# export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

char_to_ascii() {
    printf '%d' "'$1"
}

ascii_to_char() {
    input=$1

    case "$input" in
    \\x*)
        printf "%b" "$input"
        ;;
    \\o*)
        printf "%b" "\\0${input:2}"
        echo
        ;;
    \\b*)
        # 将二进制数转换为十进制数
        dec_num=$((2#${input:2}))
        hex_num=$(printf '%x' "$dec_num")
        printf "%b" "\x$hex_num"
        echo
        ;;
    *)
        hex_num=$(printf %x "$input")
        printf "%b" "\x$hex_num"
        ;;
    esac
}
