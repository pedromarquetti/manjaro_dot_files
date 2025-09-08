
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

print_red() {
    echo -e "${COLORS[RED]}${1}${COLORS[OFF]}\n"
    sleep 2
}

print_yellow () {
    echo -e "${COLORS[YELLOW]}${1}${COLORS[OFF]}\n";
}

print_green() {
    echo -e "${COLORS[GREEN]}${1}${COLORS[OFF]}\n";
}

print_cyan() {
    echo -e "${COLORS[CYAN]}${1}${COLORS[OFF]}\n";
}

print_cyan 'updating and installing stuff'
sudo pacman -Syu --no-confirm git wget curl gcc python3 

print_cyan "checking if Fast Node Manager is installed!"
if [[ -f ~/.local/share/fnm/fnm ]]; then
	print_green "fnm installed, installing node"
	fnm install --latest && fnm use "$(fnm list-remote --latest)"
else

    print_red "NVM not installed! installing... " 
    curl -fsSL https://fnm.vercel.app/install | bash
fi

print_cyan "Checking if Neovim is installed"
if [[ ! -f /usr/bin/nvim ]]; then
    print_cyan "nvim not found on /usr/bin/..."
    
    sudo curl -o /usr/bin/nvim -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage &&
    sudo chmod o-w,a+rx /usr/bin/nvim
    print_green "done!"
fi

print_cyan "Cloning my configs..."
git clone https://github.com/pedromarquetti/neovim_config.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
print_green "Cloned! Run nvim to finish setup"

