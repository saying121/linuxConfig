#!/bin/bash

which_term() {
    term=$(perl -lpe 's/\0/ /g' \
        /proc/$(xdotool getwindowpid $(xdotool getactivewindow))/cmdline)

    ## Enable extended globbing patterns
    # shopt -s extglob
    # case $term in
    #     ## If this terminal is a python or perl program,
    #     ## then the emulator's name is likely the second
    #     ## part of it
    #     */python*|*/perl*    )
    #      term=$(basename "$(readlink -f $(echo "$term" | cut -d ' ' -f 2))")
    #      version=$(pacman -Qs "$term" | awk '/^ii/{print $3}')
    #      ;;
    #     ## The special case of gnome-terminal
    #     *gnome-terminal-server* )
    #       term="gnome-terminal"
    #     ;;
    #     ## For other cases, just take the 1st
    #     ## field of $term
    #     * )
    #       term=${term/% */}
    #     ;;
    #  esac
    #  version=$(pacman -Qs "$term" | awk '/^ii/{print $3}')
    # echo "$term  $version"
    echo "$term"
}
echo $(perl -lpe 's/\0/ /g' /proc/$(xdotool getwindowpid $(xdotool getactivewindow))/cmdline)
# ps -aux | grep `ps -p $$ -o ppid=` | awk 'NR==1{print $NF}'

shellname=$(ps -p $$ -o comm=)
termname=$(ps -p $(ps -p $$ -o ppid=) -o comm=)
echo "The shell name is $shellname"
echo "The terminal name is $termname"
