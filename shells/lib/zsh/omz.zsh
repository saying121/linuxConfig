if [[ -e /usr/share/doc/find-the-command/ftc.zsh ]]; then
    source /usr/share/doc/find-the-command/ftc.zsh
else
    zi ice wait lucid
    zi snippet OMZP::command-not-found
fi

zi ice wait lucid
zi snippet OMZP::extract
zi ice lucid wait has'thefuck'
zi snippet OMZP::thefuck

zi ice wait lucid
zi snippet OMZL::clipboard.zsh
zi ice wait lucid
zi snippet OMZL::functions.zsh

zi snippet OMZL::git.zsh
zi ice wait lucid
zi snippet OMZP::git

zi snippet OMZP::last-working-dir
