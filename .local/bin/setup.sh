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

setup_git(){
    [[ -f /usr/bin/git || -f /bin/git ]] ||
        print_red "git not found! installing" 
        sudo pacman -S git
}

install_zsh(){
    if [[ ! -f /bin/zsh || ! -f /usr/bin/zsh ]]; then
        print_red "zsh not found, installing... "
        sudo pacman -Syu zsh
        sleep 1
    fi
}

config(){ # alias used to make it easier to work with these files
    /usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" "$@"
}

setup_env(){
    print_cyan "creating a bckp folder"
    mkdir -v -p "$HOME"/.dot-backup/{.config-bckp,.local/bin}

    print_cyan "moving old zshrc from HOME"
    if [[ -f $HOME/.zshrc ]]; then
        mv "$HOME"/.zshrc "$HOME"/.dot-backup 
    fi
    if [[ -d $HOME/.config ]]; then
        print_cyan "copying .config folder" 
        mv -v "$HOME"/.config "$HOME"/.dot-backup/.config-bckp 
    fi
    if [[ -d $HOME/.backup ]]; then
        print_red "backup dir. found, moving it "
        mv -v "$HOME"/.backup "$HOME"/.dot-backup
    fi
    if [[ -d $HOME/.cfg ]]; then   
        print_red ".cfg dir. found, moving it "
        mv -v "$HOME"/.cfg "$HOME"/.dot-backup
    fi

}

function install_code(){
    if [[ ! -f /bin/code ]]; then
        print_red "vscode not found at /bin/code"
        print_cyan "installing"
        yay -Syu base-devel vscodium-bin
    fi
    if [[ ! -f /bin/code ]]; then
        return 1
    fi
    
}

function install_games(){
    sudo pacman -Syu steam lutris wine discord heroic --noconfirm
}

function install_misc(){
    sudo pacman -Syu --noconfirm gufw vlc qbittorrent gimp onlyoffice telegram-desktop

    print_cyan "Installing CLI spotify client..."

    if [[ ! -x /bin/cargo ]]; then
        setup_rust
    fi

    cd /tmp/ && git clone https://github.com/aome510/spotify-player && cd spotify-player && cargo install spotify-player --features notify,daemon,fzf  

    if [[ -f $HOME/.cargo/bin/spotify_player ]]; then
        mv $HOME/.cargo/bin/spotify_player $HOME/.local/bin/spotify
    fi
}

setup_rust() {
    print_green "setting up rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

install_nodemanager() {
    print_cyan "checking if Fast Node Manager is installed!"
    if [[ -f ~/.local/share/fnm/fnm ]]; then
        print_green "fnm installed, installing node"
        fnm install --latest && fnm use "$(fnm list-remote --latest)"
    else
        print_red "FNM not installed! installing... " 
        curl -fsSL https://fnm.vercel.app/install | bash
    fi

}

install_nerdfont() {
    print_cyan "Installing NerdFont Ubuntu Mono..."
    if [[ ! -d /usr/share/fonts/NerdFont-Ubuntu/ ]]; then
        print_green "no NerdFont dir, creating..."
        mkdir -v -R /usr/share/fonts/NerdFont-Ubuntu/
    fi
    curl -L -o /tmp/Ubuntu.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/UbuntuMono.zip &&
    unzip -d /usr/share/fonts/NerdFont-Ubuntu/ /tmp/Ubuntu.zip
    print_green "Fonts installed"
}

main(){
    cd ~ || exit
    print_cyan "Hi $(whoami), how are you?"
    print_cyan "Let's update everything first..."
    sudo pacman -Syu --noconfirm wget curl make python3 yay git base-devel lbzip2 bzip2 
    print_cyan "Let's install git first"
    setup_git &&
    print_green "git installed"
    print_cyan "installing latest btop verison!"
    wget https://github.com/aristocratos/btop/releases/latest/download/btop-x86_64-linux-musl.tbz -v -P /tmp/ && sudo mkdir -v -p /usr/local/share/ && sudo tar xvjf /tmp/btop-x86_64-linux-musl.tbz -C /usr/local/share/ && sudo make -C /usr/local/share/btop/ &&
    # NOTE: btop uninstall file is in /usr/local/share/btop/
    print_green "Btop installed! to uninstall go to /usr/local/share/btop/ and run make uninstall"
    print_cyan "now, checking if zsh is installed... "
    install_zsh && 
    print_green "zsh installed"
    print_cyan "and install vscode now"
    install_code && 
    print_green "vscode installed... yayyyy"
    print_green "extensions installed!"
    print_cyan "installing some game launchers"
    install_games &&
    print_green "launchers installed"
    print_cyan "installing misc. stuff"
    install_misc &&
    print_green "misc. stuff installed"
    print_green "setting up Node Manager" &&
    install_nodemanager && 
    print_red "----------"
    print_red "This script WILL override some dotfiles and .config files, make sure you know what you're doing!!!\n\n\nyou have 20 secs to ^C and exit!!!"
    print_red "----------"
    sleep 20
    print_green "ok, continuing..."
    setup_env &&
    print_cyan "ok, getting my config files"
    git clone --bare https://github.com/pedromarquetti/cfg_files.git "$HOME"/.cfg && 

    print_green "Done, Running checkout"

    config checkout &&

    [[ $(config checkout) ]] && 
            print_red "something happened, trying again"
            print_cyan "Backing up pre-existing dot files.";

            config checkout 2>&1 | grep -E '^(M\s+|\s+)' | awk '{print $2}' | while read -r file; do mkdir -p "$HOME/.dot-backup/$(dirname "$file")"; cp "$HOME"/"$file" "$HOME/.dot-backup/$file"; done

    config checkout &&

    config config status.showUntrackedFiles no && 
    chsh -s /bin/zsh
    print_yellow "change shell with chsh -s /bin/zsh, then login again!"
    print_yellow "for some reason, if i run chsh from here, the shell does not change"

    print_cyan "Running neovim setup script"
    bash "$HOME"/.local/bin/setup_nvim.sh
    
    print_cyan "For a better TTS, use https://github.com/Elleo/pied"
    
    /bin/zsh
}

main
