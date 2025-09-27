# History configurations
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000

# dup. ignore opts
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt APPENDHISTORY

export WORDCHARS='*?_.~=&;!#$%^' #ctrl+<-(or backspace/del) will treat these as part of the word
export NVIM_DIR="$HOME/.config/nvim"
export EDITOR=nvim
export VISUAL=nvim
export ZSH=$HOME/.config/zsh
export ZSH_MODULES=$ZSH/modules

# where i keep completions for commands
if [[ ! -d ~/.config/zsh/completions/ ]]; then
    mkdir ~/.config/zsh/completions/
fi

# source .env on cd
chpwd() {
        if [[ -f ./.env ]]; then
            source ./.env
            echo "Sourced .env in $PWD"
        fi
}


fpath=(~/.config/zsh/completions/ $fpath)

# Check if Git dir exists
[[ -d ~/.config/zsh/modules ]] || 
    # || ==> right-side code will only exec if left side code == false
    # ^ if [[ ! -d ~/Git ]]...
    # The opposite would be [[ ... ]] &&..
    echo "Creating Git dir at ~" \ 
    mkdir -p $ZSH_MODULES

# Download Znap, if it's not there yet.
[[ -f $ZSH_MODULES/zsh-snap/znap.zsh ]] || 
    # explanation for this syntax: 
    # https://unix.stackexchange.com/questions/24684/confusing-use-of-and-operators
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git $ZSH_MODULES/zsh-snap


source $ZSH_MODULES/zsh-snap/znap.zsh

# `znap source` automatically downloads and starts your plugins.
znap source jeffreytse/zsh-vi-mode
znap source zsh-users/zsh-syntax-highlighting
znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-autosuggestions

source $HOME/.profile # i keep some other configs here, you can comment this line out if you want

# zsh-vi-mode options
ZVM_KEYTIMEOUT=0.01
ZVM_ESCAPE_KEYTIMEOUT=0.01


setopt autocd              # change directory just by typing its name
setopt correct             # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt
setopt prompt_subst

# configure key keybindings
bindkey '^K' kill-whole-line                    # kill whole line
bindkey ' ' magic-space                         # do history expansion on space
bindkey '^[[3;5~' kill-word                     # ctrl + delete -> kill word foward
bindkey '^H' backward-kill-word                 # kill word left of cursor << this key can vary
# bindkey '^?' backward-kill-word               # if the above doesn't work, try this
bindkey '^[[3~' delete-char                     # delete
bindkey '^[[1;5C' forward-word                  # ctrl + ->
bindkey '^[[1;5D' backward-word                 # ctrl + <-
bindkey '^h' backward-word                      # ctrl+B forward word
bindkey '^l' forward-word                       # ctrl+w forward word
bindkey '^[[5~' beginning-of-buffer-or-history  # page up
bindkey '^[[6~' end-of-buffer-or-history        # page down
bindkey '^[[H'  beginning-of-line                # home
bindkey '^[[F'  end-of-line                      # end
bindkey '^[[Z'  undo                             # shift + tab undo last action
bindkey '^ '    autosuggest-accept	        # accept autosuggest with ctrl + space 
bindkey '^I'    menu-complete                   # Tab to cycle through options

# enable completion features
autoload -Uz compinit && compinit 
zstyle ':completion:*:*:*:*:*' menu select 
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

# enable git status
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes  yes

zstyle ':vcs_info:*' stagedstr '%F{green}<S>%f'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}<U>%f'

zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3} %c%u%F{5}[%F{2}%b%F{5}]%f '

# autocomplete config
zstyle ':autocomplete:*' min-input 1 # Wait until 1 character have been typed, before showing completions.

# Wait this many seconds for typing to stop, before showing completions.
zstyle ':autocomplete:*' min-delay 0.09  # seconds (float)

# custom prompt
PROMPT='${vcs_info_msg_0_}%F{green}%~ %F{white}%(!.#.$) '
RPROMPT='%F{green}%(?.√.%F{red}error code %?)%f %F{green}%n%F{white}'


# Add indicators for shell status
function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)
        PROMPT='${vcs_info_msg_0_}%F{green}%~ %F{white}%(!.#.$) %K{#4287f5}%F{black}N%k%f  '
    ;;
    $ZVM_MODE_INSERT)
        PROMPT='${vcs_info_msg_0_}%F{green}%~ %F{white}%(!.#.$) %K{#6fde57}%F{black}I%k%f  '
    ;;
    $ZVM_MODE_VISUAL)
        PROMPT='${vcs_info_msg_0_}%F{green}%~ %F{white}%(!.#.$) %K{#b689e0}%F{black}V%k%f  '
    ;;
    $ZVM_MODE_VISUAL_LINE)
        PROMPT='${vcs_info_msg_0_}%F{green}%~ %F{white}%(!.#.$) %K{#8b66ad}%F{black}V%k%f  '
    ;;
    $ZVM_MODE_REPLACE)
        PROMPT='${vcs_info_msg_0_}%F{green}%~ %F{white}%(!.#.$) %K{#b85e83}%F{black}V%k%f  '
    ;;
  esac
}

# Colors

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[path]=underline
ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[command-substitution]=none
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
ZSH_HIGHLIGHT_STYLES[process-substitution]=none
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
ZSH_HIGHLIGHT_STYLES[assign]=none
ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
ZSH_HIGHLIGHT_STYLES[named-fd]=none
ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'


# Take advantage of $LS_COLORS for completion as well
test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

export LESS_TERMCAP_mb=$'\E[1;31m'  # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'     # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'     # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'  # begin underline
export LESS_TERMCAP_ue=$'\E[0m'     # reset underline


#############################
# User configuration
#############################

function updater() {
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    printf "${RED}apt update:${NC} \n" &&
    sudo apt update &&
    printf "${RED}upgrading:${NC} \n" &&
    sudo apt upgrade --allow-downgrades --yes &&
    printf "${RED}upgrading dist:${NC} \n" &&
    sudo apt dist-upgrade --yes --allow-downgrades &&
    printf "${RED}autoremove\n${NC}"
    sudo apt autoremove --yes &&
    printf "${RED}updating flatpak:${NC} \n" &&
    flatpak -y update &&
    printf "${RED}upgrading flatpak:${NC} \n" &&
    flatpak -y upgrade &&
    printf "${RED}updating znap\n${NC}" &&
    znap pull

}

# fix for an TILIX error i was having
if [[ -f /usr/bin/tilix || -f /bin/tilix ]]; then
    
    if [[ ! -f /etc/profile.d/vte.sh ]]; then
        echo "/etc/profile.d/vte.sh not found!!! tilix will throw an err... "
        echo "running 'sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh'"
        sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
    fi
    if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
    fi
fi

#### custom aliases ayyy ####

# enable color support of ls, less and man, and also add handy aliases
alias l='ls -l --color=auto'
alias la='ls -A --color=auto'
alias ls='ls -lt --color=auto'
alias lss='ls -lah --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep -n -B 2 -A 2  --color=auto '
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias c='clear'

### misc
alias nano='nano -l'                # line nums
alias img='eog '                    # img opener
alias rm='rm -ri'                   # recursive  & ask to remove
alias rmf='rm -rf '                 # recursive force -- caution
alias whois='whois -H'              # hides legal stuff
alias open='gio open 2>/dev/null '  # open with default app
alias py='python3'
alias pip3update="pip freeze --user | cut -d'=' -f1 | xargs -n1 pip install -U"
alias pingg='ping -c 10'             # ping limiter
alias mkdir='mkdir -p '
alias code='vscodium '

# dotfile commands
alias config="/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME" 

# dconf aliases
alias backup_dconf="dconf dump / > $HOME/.backup/backup.dconf"
alias dconf_restore="dconf load / < $HOME/.backup/backup.dconf"

# fnm - Fast Node Manager
# NOTE: https://github.com/Schniz/fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "`fnm env --use-on-cd --version-file-strategy=recursive  --shell zsh`"
fi


