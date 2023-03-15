compinit () {
    emulate -L zsh
    setopt extendedglob
    typeset _i_dumpfile _i_files _i_line _i_done _i_dir _i_autodump=1
    typeset _i_tag _i_file _i_addfiles _i_fail=ask _i_check=yes _i_name _i_why
    while [[ $# -gt 0 && $1 = -[dDiuCw] ]]
    do
        case "$1" in
                (-d) _i_autodump=1
                shift
                if [[ $# -gt 0 && "$1" != -[dfQC] ]]
                then
                    _i_dumpfile="$1"
                    shift
                fi ;;
                (-D) _i_autodump=0
                shift ;;
                (-i) _i_fail=ign
                shift ;;
                (-u) _i_fail=use
                shift ;;
                (-C) _i_check=
                shift ;;
                (-w) _i_why=1
                shift ;;
        esac
    done
    typeset -gHA _comps _services _patcomps _postpatcomps
    typeset -gHA _compautos
    typeset -gHA _lastcomp
    if [[ -n $_i_dumpfile ]]
    then
        typeset -g _comp_dumpfile="$_i_dumpfile"
    else
        typeset -g _comp_dumpfile="${ZDOTDIR:-$HOME}/.zcompdump"
    fi
    typeset -gHa _comp_options
    _comp_options=(bareglobqual extendedglob glob multibyte multifuncdef nullglob rcexpandparam unset NO_allexport NO_aliases NO_cshnullglob NO_cshjunkiequotes NO_errexit NO_errreturn NO_globassign NO_globsubst NO_histsubstpattern NO_ignorebraces NO_ignoreclosebraces NO_kshglob NO_ksharrays NO_kshtypeset NO_markdirs NO_octalzeroes NO_posixbuiltins NO_posixidentifiers NO_shwordsplit NO_shglob NO_typesettounset NO_warnnestedvar NO_warncreateglobal)
    typeset -gH _comp_setup='local -A _comp_caller_options;
    _comp_caller_options=(${(kv)options[@]});
    setopt localoptions localtraps localpatterns ${_comp_options[@]};
    local IFS=$'\'\ \\t\\r\\n\\0\'';
    builtin enable -p \| \~ \( \? \* \[ \< \^ \# 2>&-;
    exec </dev/null;
    trap - ZERR;
    local -a reply;
    local REPLY;
    local REPORTTIME;
    unset REPORTTIME'
    typeset -ga compprefuncs comppostfuncs
    compprefuncs=()
    comppostfuncs=()
    : $funcstack
    compdef () {
        local opt autol type func delete eval new i ret=0 cmd svc
        local -a match mbegin mend
        emulate -L zsh
        setopt extendedglob
        if (( ! $# ))
        then
            print -u2 "$0: I need arguments"
            return 1
        fi
        while getopts "anpPkKde" opt
        do
            case "$opt" in
                    (a) autol=yes  ;;
                    (n) new=yes  ;;
                    ([pPkK]) if [[ -n "$type" ]]
                    then
                        print -u2 "$0: type already set to $type"
                        return 1
                    fi
                    if [[ "$opt" = p ]]
                    then
                        type=pattern
                    elif [[ "$opt" = P ]]
                    then
                        type=postpattern
                    elif [[ "$opt" = K ]]
                    then
                        type=widgetkey
                    else
                        type=key
                    fi ;;
                    (d) delete=yes  ;;
                    (e) eval=yes  ;;
            esac
        done
        shift OPTIND-1
        if (( ! $# ))
        then
            print -u2 "$0: I need arguments"
            return 1
        fi
        if [[ -z "$delete" ]]
        then
            if [[ -z "$eval" ]] && [[ "$1" = *\=* ]]
            then
                while (( $# ))
                do
                    if [[ "$1" = *\=* ]]
                    then
                        cmd="${1%%\=*}"
                        svc="${1#*\=}"
                        func="$_comps[${_services[(r)$svc]:-$svc}]"
                        [[ -n ${_services[$svc]} ]] && svc=${_services[$svc]}
                        [[ -z "$func" ]] && func="${${_patcomps[(K)$svc][1]}:-${_postpatcomps[(K)$svc][1]}}"
                        if [[ -n "$func" ]]
                        then
                            _comps[$cmd]="$func"
                            _services[$cmd]="$svc"
                        else
                            print -u2 "$0: unknown command or service: $svc"
                            ret=1
                        fi
                    else
                        print -u2 "$0: invalid argument: $1"
                        ret=1
                    fi
                    shift
                done
                return ret
            fi
            func="$1"
            [[ -n "$autol" ]] && autoload -rUz "$func"
            shift
            case "$type" in
                    (widgetkey) while [[ -n $1 ]]
                    do
                        if [[ $# -lt 3 ]]
                        then
                            print -u2 "$0: compdef -K requires <widget> <comp-widget> <key>"
                            return 1
                        fi
                        [[ $1 = _* ]] || 1="_$1"
                        [[ $2 = .* ]] || 2=".$2"
                        [[ $2 = .menu-select ]] && zmodload -i zsh/complist
                        zle -C "$1" "$2" "$func"
                        if [[ -n $new ]]
                        then
                            bindkey "$3" | IFS=$' \t' read -A opt
                            [[ $opt[-1] = undefined-key ]] && bindkey "$3" "$1"
                        else
                            bindkey "$3" "$1"
                        fi
                        shift 3
                    done ;;
                    (key) if [[ $# -lt 2 ]]
                    then
                        print -u2 "$0: missing keys"
                        return 1
                    fi
                    if [[ $1 = .* ]]
                    then
                        [[ $1 = .menu-select ]] && zmodload -i zsh/complist
                        zle -C "$func" "$1" "$func"
                    else
                        [[ $1 = menu-select ]] && zmodload -i zsh/complist
                        zle -C "$func" ".$1" "$func"
                    fi
                    shift
                    for i
                    do
                        if [[ -n $new ]]
                        then
                            bindkey "$i" | IFS=$' \t' read -A opt
                            [[ $opt[-1] = undefined-key ]] || continue
                        fi
                        bindkey "$i" "$func"
                    done ;;
                    (*) while (( $# ))
                    do
                        if [[ "$1" = -N ]]
                        then
                            type=normal
                        elif [[ "$1" = -p ]]
                        then
                            type=pattern
                        elif [[ "$1" = -P ]]
                        then
                            type=postpattern
                        else
                            case "$type" in
                                    (pattern) if [[ $1 = (#b)(*)=(*) ]]
                                    then
                                        _patcomps[$match[1]]="=$match[2]=$func"
                                    else
                                        _patcomps[$1]="$func"
                                    fi ;;
                                    (postpattern) if [[ $1 = (#b)(*)=(*) ]]
                                    then
                                        _postpatcomps[$match[1]]="=$match[2]=$func"
                                    else
                                        _postpatcomps[$1]="$func"
                                    fi ;;
                                    (*) if [[ "$1" = *\=* ]]
                                    then
                                        cmd="${1%%\=*}"
                                        svc=yes
                                    else
                                        cmd="$1"
                                        svc=
                                    fi
                                    if [[ -z "$new" || -z "${_comps[$1]}" ]]
                                    then
                                        _comps[$cmd]="$func"
                                        [[ -n "$svc" ]] && _services[$cmd]="${1#*\=}"
                                    fi ;;
                            esac
                        fi
                        shift
                    done ;;
            esac
        else
            case "$type" in
                    (pattern) unset "_patcomps[$^@]" ;;
                    (postpattern) unset "_postpatcomps[$^@]" ;;
                    (key) print -u2 "$0: cannot restore key bindings"
                    return 1 ;;
                    (*) unset "_comps[$^@]" ;;
            esac
        fi
    }
    typeset _i_wdirs _i_wfiles
    _i_wdirs=()
    _i_wfiles=()
    autoload -RUz compaudit
    if [[ -n "$_i_check" ]]
    then
        typeset _i_q
        if ! eval compaudit
        then
            if [[ -n "$_i_q" ]]
            then
                if [[ "$_i_fail" = ask ]]
                then
                    if ! read -q "?zsh compinit: insecure $_i_q, run compaudit for list.
                    Ignore insecure $_i_q and continue [y] or abort compinit [n]? "
                    then
                        print -u2 "$0: initialization aborted"
                        unfunction compinit compdef
                        unset _comp_dumpfile _comp_secure compprefuncs comppostfuncs _comps _patcomps _postpatcomps _compautos _lastcomp
                        return 1
                    fi
                fi
                fpath=(${fpath:|_i_wdirs})
                (( $#_i_wfiles )) && _i_files=("${(@)_i_files:#(${(j:|:)_i_wfiles%.zwc})}")
                (( $#_i_wdirs )) && _i_files=("${(@)_i_files:#(${(j:|:)_i_wdirs%.zwc})/*}")
            fi
            typeset -g _comp_secure=yes
        fi
    fi
    autoload -RUz compdump compinstall
    _i_done=''
    if [[ -f "$_comp_dumpfile" ]]
    then
        if [[ -n "$_i_check" ]]
        then
            IFS=$' \t' read -rA _i_line < "$_comp_dumpfile"
            if [[ _i_autodump -eq 1 && $_i_line[2] -eq $#_i_files && $ZSH_VERSION = $_i_line[4] ]]
            then
                builtin . "$_comp_dumpfile"
                _i_done=yes
            elif [[ _i_why -eq 1 ]]
            then
                print -nu2 "Loading dump file skipped, regenerating"
                local pre=" because: "
                if [[ _i_autodump -ne 1 ]]
                then
                    print -nu2 $pre"-D flag given"
                    pre=", "
                fi
                if [[ $_i_line[2] -ne $#_i_files ]]
                then
                    print -nu2 $pre"number of files in dump $_i_line[2] differ from files found in \$fpath $#_i_files"
                    pre=", "
                fi
                if [[ $ZSH_VERSION != $_i_line[4] ]]
                then
                    print -nu2 $pre"zsh version changed from $_i_line[4] to $ZSH_VERSION"
                fi
                print -u2
            fi
        else
            builtin . "$_comp_dumpfile"
            _i_done=yes
        fi
    elif [[ _i_why -eq 1 ]]
    then
        print -u2 "No existing compdump file found, regenerating"
    fi
    if [[ -z "$_i_done" ]]
    then
        typeset -A _i_test
        for _i_dir in $fpath
        do
            [[ $_i_dir = . ]] && continue
            (( $_i_wdirs[(I)$_i_dir] )) && continue
            for _i_file in $_i_dir/^([^_]*|*~|*.zwc)(N)
            do
                _i_name="${_i_file:t}"
                (( $+_i_test[$_i_name] + $_i_wfiles[(I)$_i_file] )) && continue
                _i_test[$_i_name]=yes
                IFS=$' \t' read -rA _i_line < $_i_file
                _i_tag=$_i_line[1]
                shift _i_line
                case $_i_tag in
                        (\#compdef) if [[ $_i_line[1] = -[pPkK](n|) ]]
                        then
                            compdef ${_i_line[1]}na "${_i_name}" "${(@)_i_line[2,-1]}"
                        else
                            compdef -na "${_i_name}" "${_i_line[@]}"
                        fi ;;
                        (\#autoload) autoload -rUz "$_i_line[@]" ${_i_name}
                        [[ "$_i_line" != \ # ]] && _compautos[${_i_name}]="$_i_line"  ;;
				esac
			done
		done
		if [[ $_i_autodump = 1 ]]
		then
			compdump
		fi
	fi
	for _i_line in complete-word delete-char-or-list expand-or-complete expand-or-complete-prefix list-choices menu-complete menu-expand-or-complete reverse-menu-complete
	do
		zle -C $_i_line .$_i_line _main_complete
	done
	zle -la menu-select && zle -C menu-select .menu-select _main_complete
	bindkey '^i' | IFS=$' \t' read -A _i_line
	if [[ ${_i_line[2]} = expand-or-complete ]] && zstyle -a ':completion:' completer _i_line && (( ${_i_line[(i)_expand]} <= ${#_i_line} ))
	then
		bindkey '^i' complete-word
	fi
	unfunction compinit compaudit
	autoload -RUz compinit compaudit
	return 0
}
