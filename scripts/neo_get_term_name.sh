#!/bin/bash

get_term() {
    # If function was run, stop here.
    ((term_run == 1)) && return

    # Workaround for macOS systems that
    # don't support the block below.
    case $TERM_PROGRAM in
    "iTerm.app") term="iTerm2" ;;
    "Terminal.app") term="Apple Terminal" ;;
    "Hyper") term="HyperTerm" ;;
    *) term="${TERM_PROGRAM/\.app/}" ;;
    esac

    # Most likely TosWin2 on FreeMiNT - quick check
    [[ "$TERM" == "tw52" || "$TERM" == "tw100" ]] && term="TosWin2"
    [[ "$SSH_CONNECTION" ]] && term="$SSH_TTY"
    [[ "$WT_SESSION" ]] && term="Windows Terminal"

    # Check $PPID for terminal emulator.
    while [[ -z "$term" ]]; do
        parent="$(get_ppid "$parent")"
        [[ -z "$parent" ]] && break
        name="$(get_process_name "$parent")"

        case ${name// /} in
        "${SHELL/*\//}" | *"sh" | "screen" | "su"*) ;;

        "login"* | *"Login"* | "init" | "(init)")
            term="$(tty)"
            ;;

        "ruby" | "1" | "tmux"* | "systemd" | "sshd"* | "python"* | "USER"*"PID"* | "kdeinit"* | "launchd"*)
            break
            ;;

        "gnome-terminal-") term="gnome-terminal" ;;
        "urxvtd") term="urxvt" ;;
        *"nvim") term="Neovim Terminal" ;;
        *"NeoVimServer"*) term="VimR Terminal" ;;

        *)
            # Fix issues with long process names on Linux.
            [[ $os == Linux ]] && term=$(realpath "/proc/$parent/exe")

            term="${name##*/}"

            # Fix wrapper names in Nix.
            [[ $term == .*-wrapped ]] && {
                term="${term#.}"
                term="${term%-wrapped}"
            }
            ;;
        esac
    done

    # Log that the function was run.
    term_run=1

    echo $term
}

name=$(get_term)
echo $name
