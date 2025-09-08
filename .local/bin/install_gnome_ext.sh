#!/bin/bash

declare -rA COLORS=(
    [RED]=$'\033[0;31m'
    [GREEN]=$'\033[0;32m'
    [BLUE]=$'\033[0;34m'
    [PURPLE]=$'\033[0;35m'
    [CYAN]=$'\033[0;36m'
    [WHITE]=$'\033[0;37m'
    [YELLOW]=$'\033[0;33m'
    [BOLD]=$'\033[1m'
    [OFF]=$'\033[0m'
)

print_red () {
     echo -e "${COLORS[RED]}${1}${COLORS[OFF]}\n"
}

print_yellow () {
    echo -e "${COLORS[YELLOW]}${1}${COLORS[OFF]}\n"
    sleep 1
}

print_green () {
    echo -e "${COLORS[GREEN]}${1}${COLORS[OFF]}\n"
    sleep 1
}

print_cyan () {
    echo -e "${COLORS[CYAN]}${1}${COLORS[OFF]}\n"
}

function install_gnome_extensions(){

    # check if .local/share/gnome-shell/extensions/ exists
    if [[ ! -d $XDG_DATA_HOME/gnome-shell/extensions ]]; then
        print_red "extensions dir. not found, creating it"
        sudo mkdir -v -p "$XDG_DATA_HOME"/gnome-shell/extensions
    fi
    # install extensions
    print_cyan "installing Dash2Dock Lite"
    sudo git clone https://github.com/icedman/dash2dock-lite.git "$XDG_DATA_HOME"/gnome-shell/extensions/dash2dock-lite &&
    cd "$XDG_DATA_HOME"/gnome-shell/extensions/dash2dock-lite &&
    sudo make &&
    cd ~ || exit
    print_green "Dash2Dock Lite installed"

    print_cyan "installing Search Light"
    sudo git clone https://github.com/icedman/search-light "$XDG_DATA_HOME"/gnome-shell/extensions/search-light &&
    cd "$XDG_DATA_HOME"/gnome-shell/extensions/search-light &&
    sudo make &&
    cd ~ || exit
    print_green "Search Light installed"

}

    print_cyan "setting up gnome extensions"
    install_gnome_extensions 
