#!/usr/bin/env zsh

zi ice lucid wait'2' \
    has'uv' \
    as'completion' \
    id-as'uv' \
    blockf \
    atclone'uv generate-shell-completion zsh >_uv' \
    atpull'%atclone'
zi load z-shell/null

zi ice lucid wait'2' \
    has'jj' \
    as'completion' \
    id-as'jujutsu' \
    blockf \
    atclone'jj util completion zsh > _jj' \
    atpull'%atclone'
zi load z-shell/null

zi ice lucid wait'2' \
    has'lcode' \
    as'completion' \
    id-as'lcode' \
    blockf \
    atclone'lcode --generate zsh > _lcode' \
    atpull'%atclone'
zi load z-shell/null

zi ice as"completion"
zi light https://github.com/ziglang/shell-completions

zi ice lucid wait as'completion'
zi light zsh-users/zsh-completions

zi ice lucid wait as'completion' blockf has'alacritty'
zi snippet https://github.com/alacritty/alacritty/blob/master/extra/completions/_alacritty

zi ice lucid wait as'completion' blockf has'beet'
zi snippet https://github.com/beetbox/beets/blob/master/extra/_beet

zi ice lucid wait as'completion' blockf has'wl-copy'
zi snippet https://github.com/bugaevc/wl-clipboard/blob/master/completions/zsh/_wl-copy

zi ice lucid wait as'completion' blockf has'wl-paste'
zi snippet https://github.com/bugaevc/wl-clipboard/blob/master/completions/zsh/_wl-paste

zi ice lucid wait as'completion' blockf has'rg' mv'rg.zsh -> _rg'
zi snippet https://github.com/BurntSushi/ripgrep/blob/master/crates/core/flags/complete/rg.zsh

zi ice lucid wait as'completion' blockf has'tldr' mv'zsh_tealdeer -> _tldr'
zi snippet https://github.com/dbrgn/tealdeer/blob/main/completion/zsh_tealdeer

zi ice lucid wait as'completion' blockf has'docker'
zi snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

zi ice lucid wait as'completion' blockf has'mise'
zi snippet https://github.com/jdx/mise/blob/main/completions/_mise

zi ice lucid wait as'completion' blockf has'launchctl'
zi snippet https://github.com/nilsonholger/osx-zsh-completions/blob/master/_launchctl

# zi ice lucid wait as'completion' blockf mv'git-completion.zsh -> _git'
# zi snippet https://github.com/git/git/blob/master/contrib/completion/git-completion.zsh

zi ice lucid wait as'completion' blockf has'tmux' pick'completion/zsh'
zi light greymd/tmux-xpanes

zi ice lucid wait as'completion' blockf has'buku'
zi snippet https://github.com/jarun/Buku/blob/master/auto-completion/zsh/_buku

zi ice lucid wait as'completion' blockf has'mpv'
zi snippet https://github.com/mpv-player/mpv/blob/master/etc/_mpv.zsh

zi ice lucid wait as'completion' blockf has'rustc'
zi snippet https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/rust/_rustc

zi ice lucid wait as'completion' blockf has'cargo'
zi snippet https://github.com/rust-lang/cargo/blob/master/src/etc/_cargo

zi ice lucid wait as'completion' blockf has'bun'
zi snippet https://github.com/oven-sh/bun/blob/main/completions/bun.zsh

zi ice lucid wait as'completion' blockf has'pandoc'
zi light srijanshetty/zsh-pandoc-completion

zi ice lucid wait as'completion' blockf has'yadm'
zi snippet https://github.com/TheLocehiliosan/yadm/blob/master/completion/zsh/_yadm

zi ice lucid wait as'completion' blockf has'ghq'
zi snippet https://github.com/x-motemen/ghq/blob/master/misc/zsh/_ghq

zi ice wait lucid as'completion' blockf has'zoxide'
zi snippet https://github.com/ajeetdsouza/zoxide/blob/main/contrib/completions/_zoxide

# zi ice wait lucid as'completion' blockf has'sing-box'
zi snippet https://github.com/SagerNet/sing-box/blob/main/release/completions/sing-box.zsh

zi light sunlei/zsh-ssh

if command -v brew >/dev/null; then
    zi wait pack atload=+"zicompinit_fast; zicdreplay" for brew-completions
fi

zi ice wait lucid pick'autopair.zsh'
zi load hlissner/zsh-autopair

# export ATUIN_NOBIND="true"
zi ice lucid wait has'atuin'
zi load ellie/atuin
# bindkey '^r' atuin-search

zi ice lucid wait has'fzf'
zi light Aloxaf/fzf-tab
zi ice wait lucid
zi light Freed-Wu/fzf-tab-source
source ~/.linuxConfig/shells/lib/zsh/fzf-tab.zsh

zi ice wait lucid atload"!_zsh_autosuggest_start"
zi load zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
